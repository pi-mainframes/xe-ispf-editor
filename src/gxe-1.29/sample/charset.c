/*
 * Modifications Copyright 1993, 1994, 1995, 1996, 1999, 2000, 2001, 2002,
 *  2003, 2004, 2005, 2006, 2007 by Paul Mattes.
 * Original X11 Port Copyright 1990 by Jeff Sparkes.
 *  Permission to use, copy, modify, and distribute this software and its
 *  documentation for any purpose and without fee is hereby granted,
 *  provided that the above copyright notice appear in all copies and that
 *  both that copyright notice and this permission notice appear in
 *  supporting documentation.
 *
 * Copyright 1989 by Georgia Tech Research Corporation, Atlanta, GA 30332.
 *  All Rights Reserved.  GTRC hereby grants public use of this software.
 *  Derivative works based on this software must incorporate this copyright
 *  notice.
 *
 * x3270, c3270, s3270 and tcl3270 are distributed in the hope that they will
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file LICENSE
 * for more details.
 */

/*
 *	charset.c
 *		This module handles character sets.
 */

#include "globals.h"

#include "resources.h"
#include "appres.h"
#include "cg.h"

#include "charsetc.h"
#include "kybdc.h"
#include "popupsc.h"
#if defined(X3270_DISPLAY) || (defined(C3270) && !defined(_WIN32)) /*[*/
#include "screenc.h"
#endif /*]*/
#include "tablesc.h"
#include "utf8c.h"
#include "utilc.h"
#include "widec.h"

#include <errno.h>
#include <locale.h>
#if !defined(_WIN32) /*[*/
#include <langinfo.h>
#endif /*]*/

#define EURO_SUFFIX	"-euro"
#define ES_SIZE		(sizeof(EURO_SUFFIX) - 1)

#if defined(_WIN32) /*[*/
extern void set_display_charset(char *dcs);
#endif /*]*/

/* Globals. */
Boolean charset_changed = False;
#define DEFAULT_CGEN	0x02b90000
#define DEFAULT_CSET	0x00000025
unsigned long cgcsgid = DEFAULT_CGEN | DEFAULT_CSET;
unsigned long cgcsgid_dbcs = 0L;
char *default_display_charset = "3270cg-1a,3270cg-1,iso8859-1";
char *converter_names;
char *encoding;
#if defined(X3270_DISPLAY) /*[*/
unsigned char xk_selector = 0;
#endif
unsigned char auto_keymap = 0;

/* Statics. */
static enum cs_result resource_charset(char *csname, char *cs, char *ftcs);
typedef enum { CS_ONLY, FT_ONLY, BOTH } remap_scope;
static enum cs_result remap_chars(char *csname, char *spec, remap_scope scope,
    int *ne);
static void remap_one(unsigned char ebc, KeySym iso, remap_scope scope,
    Boolean one_way);
#if defined(DEBUG_CHARSET) /*[*/
static enum cs_result check_charset(void);
static char *char_if_ascii7(unsigned long l);
#endif /*]*/
static void set_cgcsgids(char *spec);
static int set_cgcsgid(char *spec, unsigned long *idp);
static void set_charset_name(char *csname);

static char *charset_name = CN;

static void
charset_defaults(void)
{
	/* Go to defaults first. */
	(void) memcpy((char *)ebc2cg, (char *)ebc2cg0, 256);
	(void) memcpy((char *)cg2ebc, (char *)cg2ebc0, 256);
	(void) memcpy((char *)ebc2asc, (char *)ebc2asc0, 256);
	(void) memcpy((char *)asc2ebc, (char *)asc2ebc0, 256);
#if defined(X3270_FT) /*[*/
	(void) memcpy((char *)ft2asc, (char *)ft2asc0, 256);
	(void) memcpy((char *)asc2ft, (char *)asc2ft0, 256);
#endif /*]*/
	clear_xks();
}

static unsigned char save_ebc2cg[256];
static unsigned char save_cg2ebc[256];
static unsigned char save_ebc2asc[256];
static unsigned char save_asc2ebc[256];
#if defined(X3270_FT) /*[*/
static unsigned char save_ft2asc[256];
static unsigned char save_asc2ft[256];
#endif /*]*/

static void
save_charset(void)
{
	(void) memcpy((char *)save_ebc2cg, (char *)ebc2cg, 256);
	(void) memcpy((char *)save_cg2ebc, (char *)cg2ebc, 256);
	(void) memcpy((char *)save_ebc2asc, (char *)ebc2asc, 256);
	(void) memcpy((char *)save_asc2ebc, (char *)asc2ebc, 256);
#if defined(X3270_FT) /*[*/
	(void) memcpy((char *)save_ft2asc, (char *)ft2asc, 256);
	(void) memcpy((char *)save_asc2ft, (char *)asc2ft, 256);
#endif /*]*/
}

static void
restore_charset(void)
{
	(void) memcpy((char *)ebc2cg, (char *)save_ebc2cg, 256);
	(void) memcpy((char *)cg2ebc, (char *)save_cg2ebc, 256);
	(void) memcpy((char *)ebc2asc, (char *)save_ebc2asc, 256);
	(void) memcpy((char *)asc2ebc, (char *)save_asc2ebc, 256);
#if defined(X3270_FT) /*[*/
	(void) memcpy((char *)ft2asc, (char *)save_ft2asc, 256);
	(void) memcpy((char *)asc2ft, (char *)save_asc2ft, 256);
#endif /*]*/
}

/* Get a character set definition. */
static char *
get_charset_def(const char *csname)
{
	return get_fresource("%s.%s", ResCharset, csname);
}

#if defined(X3270_DBCS) /*[*/
/*
 * Initialize the DBCS conversion functions, based on resource values.
 */
static int
wide_resource_init(char *csname)
{
	char *cn, *en;

	cn = get_fresource("%s.%s", ResDbcsConverters, csname);
	if (cn == CN)
		return 0;

	en = get_fresource("%s.%s", ResLocalEncoding, csname);
	if (en == CN)
		en = appres.local_encoding;
	Replace(converter_names, cn);
	Replace(encoding, en);

	return wide_init(cn, en);

}
#endif /*]*/

/*
 * Change character sets.
 */
enum cs_result
charset_init(char *csname)
{
	char *cs, *ftcs;
	enum cs_result rc;
	char *ccs, *cftcs;
#if defined(X3270_DISPLAY) /*[*/
	char *xks;
#endif /*]*/
	char *ak;
#if !defined(_WIN32) /*[*/
	char *codeset_name;
#endif /*]*/

#if !defined(_WIN32) /*[*/
	/* Get all of the locale stuff right. */
	setlocale(LC_ALL, "");

	/* Figure out the locale code set (character set encoding). */
	codeset_name = nl_langinfo(CODESET);
	set_codeset(codeset_name);
#endif /*]*/

	/* Do nothing, successfully. */
	if (csname == CN || !strcasecmp(csname, "us")) {
		charset_defaults();
		set_cgcsgids(CN);
		set_charset_name(CN);
#if defined(X3270_DISPLAY) || (defined(C3270) && !defined(_WIN32)) /*[*/
		(void) screen_new_display_charsets(default_display_charset,
		    "us");
#else /*][*/
#if defined(_WIN32) /*[*/
		set_display_charset("iso8859-1");
#else /*][*/
		utf8_set_display_charsets(default_display_charset, "us");
#endif /*]*/
#endif /*]*/
		return CS_OKAY;
	}

	/* Figure out if it's already in a resource or in a file. */
	cs = get_charset_def(csname);
	if (cs == CN &&
	    strlen(csname) > ES_SIZE &&
	    !strcasecmp(csname + strlen(csname) - ES_SIZE, EURO_SUFFIX)) {
		char *basename;

		/* Grab the non-Euro definition. */
		basename = xs_buffer("%.*s", strlen(csname) - ES_SIZE, csname);
		cs = get_charset_def(basename);
		Free(basename);
	}
	if (cs == CN)
		return CS_NOTFOUND;

	/* Grab the File Transfer character set. */
	ftcs = get_fresource("%s.%s", ResFtCharset, csname);

	/* Copy strings. */
	ccs = NewString(cs);
	cftcs = (ftcs == NULL)? NULL: NewString(ftcs);

	/* Save the current definitions, and start over with the defaults. */
	save_charset();
	charset_defaults();

	/* Check for auto-keymap. */
	ak = get_fresource("%s.%s", ResAutoKeymap, csname);
	if (ak != NULL)
		auto_keymap = !strcasecmp(ak, "true");
	else
		auto_keymap = 0;

	/* Interpret them. */
	rc = resource_charset(csname, ccs, cftcs);

	/* Free them. */
	Free(ccs);
	Free(cftcs);

#if defined(DEBUG_CHARSET) /*[*/
	if (rc == CS_OKAY)
		rc = check_charset();
#endif /*]*/

	if (rc != CS_OKAY)
		restore_charset();
#if defined(X3270_DBCS) /*[*/
	else if (wide_resource_init(csname) < 0) {
		restore_charset();
		return CS_NOTFOUND;
	}
#endif /*]*/

#if defined(X3270_DISPLAY) /*[*/
	/* Check for an XK selector. */
	xks = get_fresource("%s.%s", ResXkSelector, csname);
	if (xks != NULL)
		xk_selector = (unsigned char) strtoul(xks, NULL, 0);
	else
		xk_selector = 0;
#endif /*]*/

	return rc;
}

/* Set a CGCSGID.  Return 0 for success, -1 for failure. */
static int
set_cgcsgid(char *spec, unsigned long *r)
{
	unsigned long cp;
	char *ptr;

	if (spec != CN &&
	    (cp = strtoul(spec, &ptr, 0)) &&
	    ptr != spec &&
	    *ptr == '\0') {
		if (!(cp & ~0xffffL))
			*r = DEFAULT_CGEN | cp;
		else
			*r = cp;
		return 0;
	} else
		return -1;
}

/* Set the CGCSGIDs. */
static void
set_cgcsgids(char *spec)
{
	int n_ids = 0;
	char *spec_copy;
	char *buf;
	char *token;

	if (spec != CN) {
		buf = spec_copy = NewString(spec);
		while (n_ids >= 0 && (token = strtok(buf, "+")) != CN) {
			unsigned long *idp = NULL;

			buf = CN;
			switch (n_ids) {
			case 0:
			    idp = &cgcsgid;
			    break;
#if defined(X3270_DBCS) /*[*/
			case 1:
			    idp = &cgcsgid_dbcs;
			    break;
#endif /*]*/
			default:
			    popup_an_error("Extra CGCSGID(s), ignoring");
			    break;
			}
			if (idp == NULL)
				break;
			if (set_cgcsgid(token, idp) < 0) {
				popup_an_error("Invalid CGCSGID '%s', ignoring",
				    token);
				n_ids = -1;
				break;
			}
			n_ids++;
		}
		Free(spec_copy);
		if (n_ids > 0)
			return;
	}

	cgcsgid = DEFAULT_CGEN | DEFAULT_CSET;
#if defined(X3270_DBCS) /*[*/
	cgcsgid_dbcs = 0L;
#endif /*]*/
}

/* Set the global charset name. */
static void
set_charset_name(char *csname)
{
	if (csname == CN) {
		Replace(charset_name, NewString("us"));
		charset_changed = False;
		return;
	}
	if ((charset_name != CN && strcmp(charset_name, csname)) ||
	    (appres.charset != CN && strcmp(appres.charset, csname))) {
		Replace(charset_name, NewString(csname));
		charset_changed = True;
	}
}

/* Define a charset from resources. */
static enum cs_result
resource_charset(char *csname, char *cs, char *ftcs)
{
	enum cs_result rc;
	int ne = 0;
	char *rcs = CN;
	int n_rcs = 0;
#if defined(_WIN32) /*[*/
	char *dcs;
#endif /*]*/

	/* Interpret the spec. */
	rc = remap_chars(csname, cs, (ftcs == NULL)? BOTH: CS_ONLY, &ne);
	if (rc != CS_OKAY)
		return rc;
	if (ftcs != NULL) {
		rc = remap_chars(csname, ftcs, FT_ONLY, &ne);
		if (rc != CS_OKAY)
			return rc;
	}

	rcs = get_fresource("%s.%s", ResDisplayCharset, csname);

	/* Isolate the pieces. */
	if (rcs != CN) {
		char *rcs_copy, *buf, *token;

		buf = rcs_copy = NewString(rcs);
		while ((token = strtok(buf, "+")) != CN) {
			buf = CN;
			switch (n_rcs) {
			case 0:
#if defined(X3270_DBCS) /*[*/
			case 1:
#endif /*]*/
			    break;
			default:
			    popup_an_error("Extra %s value(s), ignoring",
				ResDisplayCharset);
			    break;
			}
			n_rcs++;
		}
	}

#if defined(X3270_DBCS) /*[*/
	/* Can't swap DBCS modes while connected. */
	if (IN_3270 && (n_rcs == 2) != dbcs) {
		popup_an_error("Can't change DBCS modes while connected");
		return CS_ILLEGAL;
	}
#endif /*]*/

#if defined(X3270_DISPLAY) || (defined(C3270) && !defined(_WIN32)) /*[*/
	if (!screen_new_display_charsets(
		    rcs? rcs: default_display_charset,
		    csname)) {
		return CS_PREREQ;
	}
#else /*][*/
#if !defined(_WIN32) /*[*/
	utf8_set_display_charsets(rcs? rcs: default_display_charset, csname);
#endif /*]*/
#if defined(X3270_DBCS) /*[*/
	if (n_rcs > 1)
		dbcs = True;
	else
		dbcs = False;
#endif /*]*/
#endif /*]*/

	/* Set up the cgcsgid. */
	set_cgcsgids(get_fresource("%s.%s", ResCodepage, csname));

#if defined(_WIN32) /*[*/
       /* See about changing the console output code page. */
       dcs = get_fresource("%s.%s", ResDisplayCharset, csname);
       if (dcs != NULL) {
	       set_display_charset(dcs);
       } else {
	       set_display_charset("iso8859-1");
       }
#endif /*]*/

	/* Set up the character set name. */
	set_charset_name(csname);

	return CS_OKAY;
}

/*
 * Map a keysym name or literal string into a character.
 * Returns NoSymbol if there is a problem.
 */
static KeySym
parse_keysym(char *s, Boolean extended)
{
	KeySym	k;

	k = StringToKeysym(s);
	if (k == NoSymbol) {
		if (strlen(s) == 1)
			k = *s & 0xff;
		else if (s[0] == '0' && s[1] == 'x') {
			unsigned long l;
			char *ptr;

			l = strtoul(s, &ptr, 16);
			if (*ptr != '\0' || (l & ~0xffff))
				return NoSymbol;
			return (KeySym)l;
		} else
			return NoSymbol;
	}
	if (k < ' ' || (!extended && k > 0xff))
		return NoSymbol;
	else
		return k;
}

/* Process a single character definition. */
static void
remap_one(unsigned char ebc, KeySym iso, remap_scope scope, Boolean one_way)
{
	unsigned char cg;

	/* Ignore mappings of EBCDIC control codes and the space character. */
	if (ebc <= 0x40)
		return;

	/* If they want to map to a NULL or a blank, make it a one-way blank. */
	if (iso == 0x0)
		iso = 0x20;
	if (iso == 0x20)
		one_way = True;

	if (!auto_keymap || iso <= 0xff) {
#if defined(X3270_FT) /*[*/
		unsigned char aa;
#endif /*]*/

		if (scope == BOTH || scope == CS_ONLY) {
			if (iso <= 0xff) {
				cg = asc2cg[iso];

				if (cg2asc[cg] == iso || iso == 0) {
					/* well-defined */
					ebc2cg[ebc] = cg;
					if (!one_way)
						cg2ebc[cg] = ebc;
				} else {
					/* into a hole */
					ebc2cg[ebc] = CG_boxsolid;
				}
			}
			if (ebc > 0x40) {
				ebc2asc[ebc] = iso;
				if (!one_way)
					asc2ebc[iso] = ebc;
			}
		}
#if defined(X3270_FT) /*[*/
		if (iso <= 0xff && ebc > 0x40) {
			/* Change the file transfer translation table. */
			if (scope == BOTH) {
				/*
				 * We have an alternate mapping of an EBCDIC
				 * code to an ASCII code.  Modify the existing
				 * ASCII(ft)-to-ASCII(desired) maps.
				 *
				 * This is done by figuring out which ASCII
				 * code the host usually translates the given
				 * EBCDIC code to (asc2ft0[ebc2asc0[ebc]]).
				 * Now we want to translate that code to the
				 * given ISO code, and vice-versa.
				 */
				aa = asc2ft0[ebc2asc0[ebc]];
				if (aa != ' ') {
					ft2asc[aa] = iso;
				if (iso!=0x20)  //a#@@@@ 20080731 for the case apace->unprintable//+8915I~
					asc2ft[iso] = aa;
				}
			} else if (scope == FT_ONLY) {
				/*
				 * We have a map of how the host translates
				 * the given EBCDIC code to an ASCII code.
				 * Generate the translation between that code
				 * and the ISO code that we would normally
				 * use to display that EBCDIC code.
				 */
				ft2asc[iso] = ebc2asc[ebc];
				asc2ft[ebc2asc[ebc]] = iso;
			}
		}
#endif /*]*/
	} else {
		/* Auto-keymap. */
		add_xk(iso, (KeySym)ebc2asc[ebc]);
	}
}

/*
 * Parse an EBCDIC character set map, a series of pairs of numeric EBCDIC codes
 * and keysyms.
 *
 * If the keysym is in the range 1..255, it is a remapping of the EBCDIC code
 * for a standard Latin-1 graphic, and the CG-to-EBCDIC map will be modified
 * to match.
 *
 * Otherwise (keysym > 255), it is a definition for the EBCDIC code to use for
 * a multibyte keysym.  This is intended for 8-bit fonts that with special
 * characters that replace certain standard Latin-1 graphics.  The keysym
 * will be entered into the extended keysym translation table.
 */
static enum cs_result
remap_chars(char *csname, char *spec, remap_scope scope, int *ne)
{
	char *s;
	char *ebcs, *isos;
	unsigned char ebc;
	KeySym iso;
	int ns;
	enum cs_result rc = CS_OKAY;
	Boolean is_table = False;
	Boolean one_way = False;

	/* Pick apart a copy of the spec. */
	s = spec = NewString(spec);
	while (isspace(*s)) {
		s++;
	}
	if (!strncmp(s, "#table", 6)) {
		is_table = True;
		s += 6;
	}

	if (is_table) {
		int ebc = 0;
		char *tok;
		char *ptr;

		while ((tok = strtok(s, " \t\n")) != CN) {
			if (ebc >= 256) {
				popup_an_error("Charset has more than 256 "
				    "entries");
				rc = CS_BAD;
				break;
			}
			if (tok[0] == '*') {
				one_way = True;
				tok++;
			} else
				one_way = False;
			iso = strtoul(tok, &ptr, 0);
			if (ptr == tok || *ptr != '\0' || iso > 256L) {
				if (strlen(tok) == 1)
					iso = tok[0] & 0xff;
				else {
					popup_an_error("Invalid charset "
					    "entry '%s' (#%d)",
					    tok, ebc);
					rc = CS_BAD;
					break;
				}
			}
			remap_one(ebc, iso, scope, one_way);

			ebc++;
			s = CN;
		}
		if (ebc != 256) {
			popup_an_error("Charset has %d entries, need 256", ebc);
			rc = CS_BAD;
		} else {
			/*
			 * The entire EBCDIC-to-ASCII mapping has been defined.
			 * Make sure that any printable ASCII character that
			 * doesn't now map back onto itself is mapped onto an
			 * EBCDIC NUL.
			 */
			int i;

			for (i = 0; i < 256; i++) {
				if ((i & 0x7f) > 0x20 && i != 0x7f &&
						asc2ebc[i] != 0 &&
						ebc2asc[asc2ebc[i]] != i) {
					asc2ebc[i] = 0;
				}
			}
		}
	} else {
		while ((ns = split_dresource(&s, &ebcs, &isos))) {
			char *ptr;

			(*ne)++;
			if (ebcs[0] == '*') {
				one_way = True;
				ebcs++;
			} else
				one_way = False;
			if (ns < 0 ||
			    ((ebc = strtoul(ebcs, &ptr, 0)),
			     ptr == ebcs || *ptr != '\0') ||
			    (iso = parse_keysym(isos, True)) == NoSymbol) {
				popup_an_error("Cannot parse %s \"%s\", entry %d",
				    ResCharset, csname, *ne);
				rc = CS_BAD;
				break;
			}
			remap_one(ebc, iso, scope, one_way);
		}
	}
	Free(spec);
	return rc;
}

#if defined(DEBUG_CHARSET) /*[*/
static char *
char_if_ascii7(unsigned long l)
{
	static char buf[6];

	if (((l & 0x7f) > ' ' && (l & 0x7f) < 0x7f) || l == 0xff) {
		(void) sprintf(buf, " ('%c')", (char)l);
		return buf;
	} else
		return "";
}
#endif /*]*/


#if defined(DEBUG_CHARSET) /*[*/
/*
 * Verify that a character set is not ambiguous.
 * (All this checks is that multiple EBCDIC codes map onto the same ISO code.
 *  Hmm.  God, I find the CG stuff confusing.)
 */
static enum cs_result
check_charset(void)
{
	unsigned long iso;
	unsigned char ebc;
	enum cs_result rc = CS_OKAY;

	for (iso = 1; iso <= 255; iso++) {
		unsigned char multi[256];
		int n_multi = 0;

		if (iso == ' ')
			continue;

		for (ebc = 0x41; ebc < 0xff; ebc++) {
			if (cg2asc[ebc2cg[ebc]] == iso) {
				multi[n_multi] = ebc;
				n_multi++;
			}
		}
		if (n_multi > 1) {
			xs_warning("Display character 0x%02x%s has multiple "
			    "EBCDIC definitions: X'%02X', X'%02X'%s",
			    iso, char_if_ascii7(iso),
			    multi[0], multi[1], (n_multi > 2)? ", ...": "");
			rc = CS_BAD;
		}
	}
	return rc;
}
#endif /*]*/

/* Return the current character set name. */
char *
get_charset_name(void)
{
	return (charset_name != CN)? charset_name:
	    ((appres.charset != CN)? appres.charset: "us");
}
