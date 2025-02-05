XE4S001Z TITLE '*** XE4S001Z *** DISPLAY/UPDATE SPF INFO ***'           00010030
*********************************************************************** 00020000
*#011 080626 TSO/E:DISPLAY/CHANGE SECONDS                               00020123
*#010 080626 TSO/E:SET CRE-DATE=CHG-DATE IF CDATE=0 TO DISPLAY OF SPF   00020222
*#009 080626 TSO/E:RSV FLD AFTER VVMM MAY BE SECONDS OF MOD-TIME        00020321
*#008 080626 TSO/E:RSV FLD AFTER USERNAME OF DIR ENTRY IS SPACE         00020420
*#007 080626 LIST DISPLAY COLUMN ADJUST                                 00020519
*#006 080625 SPF D/S IS NOT ONLY FOR FIXED LRECL 80                     00020166
*#005 080625 ISSUE ERRMSG WHEN STOW FAILED                              00020266
*#004 080605 0C1 ABEND WHEN PARM MISSING                                00021058
*#003 061201 SPF UPDATE FOR ALL PDS MEMBER                              00030057
*#002 061125 UPDATE SPF INFO                                            00040030
*#001 061125 USE BLDL WHEN MEMBER SPECIFIED                             00050055
********************************************************************    00060001
*ASSEMBLE MACLIB ***************************************************    00070028
*//SYSLIB   DD   DSN=SYS2.MACLIB,DISP=SHR                               00080028
*//         DD   DSN=SYS1.MACLIB,DISP=SHR                               00090028
*//         DD   DSN=SYS1.AMODGEN,DISP=SHR                              00100028
*                                                                       00110030
*(1)* DISPLAY SPF INFORMATION ON PDS DIRECTORY *********************    00120030
*                                                                       00130030
*SAMPLE JCL TO EXECUTE BATCH *                                          00140030
*//GO EXEC PGM=XE4S001Z,PARM='HERC01.SOURCE.ASM'                        00150013
*//STEPLIB DD DISP=SHR,DSN=HERC01.LOAD.ASM                              00160013
*//GO EXEC PGM=XE4S001Z,PARM='HERC01.SOURCE.ASM(MEMB)'                  00170030
*//STEPLIB DD DISP=SHR,DSN=HERC01.LOAD.ASM                              00180030
*                                                                       00190030
*CALL ON TSO *                                                          00200030
* CALL 'HERC01.LOAD.ASM(XE4S001Z)' 'HERC01.SOURCE.ASM'                  00210013
* CALL 'HERC01.LOAD.ASM(XE4S001Z)' 'HERC01.SOURCE.ASM(MEMB)'            00220030
*                                                                       00230030
*OUTPUT SAMPLE *                                                        00240030
*MEMBER LIST FOR HERC01.TEST1.SRC                                       00250028
*-DSORG=PO RECFM=FB LRECL=00080 BLKSIZE=03120                           00260028
*-NAME---  VV.MM  CREATED   LAST-UPDATED     LINE-COUNT  INITIAL USER   00270028
*@         80.00  06/11/20  06/11/20 15:27            1        1 HERC03 00280028
*@@2       -                                                            00290028
*AAAAHH    80.00  06/11/15  06/11/15 11:39           12       12 HERC03 00300028
*-END OF LIST- 000075 MEMBER (000000 ALIAS)                             00310029
*                                                                       00320030
*(2)* UPDATE  SPF INFORMATION ON PDS DIRECTORY *********************    00330030
* PARM FORMAT                                                           00340030
*  '1,DSN(MEMB),VV,MM,CDATE,UDATE,UTIME,CURLINE,INITLINE,USER'          00350035
*                                                                       00360034
*  (START BY NOT NUMERIC MEANS MISSING OPERAND EXCEPT FOR USERID)       00370034
*  (!!! RPF(V153) NEED CRE-DATE/UP-DATE/USERID TO DISPLY ON DIRLIST)    00380039
*  MEMB:WILDCARD(*/?) ALLOWED                                           00390052
*  1:FUNCTION ID:UPDATE SPF INFO                                        00400030
*  VV:VERSION                                                           00410030
*     IF MISSING,KEEP CURRENT VALUE OR SET 0 IF NO PREVIOUS INFO        00420034
*     +N FORMAT IS USED TO INCREMENT                                    00430030
*  MM:MODIFICATION LEVEL                                                00440030
*     IF MISSING,KEEP CURRENT VALUE OR SET 0 IF NO PREVIOUS INFO        00450034
*     +N FORMAT IS USED TO INCREMENT                                    00460030
*     'NOW' IS USED TO SET TO MAX VALUE OF COLUMN 79-80                 00470038
*  CDATE:CREATED DATE                                                   00480030
*     IF MISSING,KEEP CURRENT VALUE OR SET 0     IF NO PREVIOUS INFO    00490039
*     'NOW' IS USED TO SET TO TODAY                                     00500034
*     '000000' IS USED TO SET TO 0                                      00510039
*  UDATE:LAST UPDATED DATE                                              00520030
*     IF MISSING,KEEP CURRENT VALUE OR SET 0     IF NO PREVIOUS INFO    00530039
*     'NOW' IS USED TO SET TO TODAY                                     00540030
*     '000000' IS USED TO SET TO 0                                      00550039
*  UTIME:LAST UPDATED TIME                                              00560030
*     IF MISSING,KEEP CURRENT VALUE OR SET 0       IF NO PREVIOUS INFO  00570039
*     'NOW' IS USED TO SET TO CURRENT TIME                              00580031
*  CURLINE:CURRENT LINE COUNT                                           00590031
*     IF MISSING,KEEP CURRENT VALUE OR SET 0 IF NO PREVIOUS INFO        00600033
*     'NOW' IS USED TO SET CURRENT LINE COUNT BY READING MEMBER         00610034
*  INITLINE:INITIAL LINE COUNT                                          00620035
*     IF MISSING,KEEP CURRENT VALUE OR SET 0 IF NO PREVIOUS INFO.       00630035
*     'NOW' IS USED TO SET CURRENT LINE COUNT BY READING MEMBER         00640035
*  USER   :LAST UPDATED USER                                            00650031
*     IF MISSING,KEEP CURRENT VALUE OR SET BLANK IF NO PREVIOUS INFO    00660031
*SAMPLE JCL TO EXECUTE BATCH *                                          00670031
*//GO EXEC PGM=XE4S001Z,PARM=('1','HERC01.SOURCE.ASM(MEMB),',           00680033
*//        '01,21,061105,061125,2210,99,101,HERC01')                    00690031
*//GO EXEC PGM=XE4S001Z,PARM=('1','HERC01.SOURCE.ASM(MEMB),',           00700033
*//        'VV,+1,CDT,NOW,NOW,CLC,NOW,HERC01')                          00710035
*//GO EXEC PGM=XE4S001Z,PARM='1,HERC01.SOURCE.ASM(MEMB),DEL'            00720035
*//STEPLIB DD DISP=SHR,DSN=HERC01.LOAD.ASM                              00730031
********************************************************************    00740013
*GET SPF INFO                                               A#####      00750001
*            DIRECTORY ENTRY FORMAT(SIZE=X'20')                         00760001
*              +00   MEMBER NAME                                        00770001
*              +08   TTR                                                00780001
*              +0B   FLAG                                               00790001
*              +0C   VERSION                                            00800001
*              +0D   MODIFIER LEVEL                                     00810001
*              +0E   ??                                                 00820001
*              +10   CREATED DATE 00YYDDD                               00830001
*              +14   LAST CHANGED DATE 00YYDDD                          00840001
*              +18   LAST CHANGED TIME HHMM                             00850001
*              +1A   CURRENT LINE SIZE                                  00860001
*              +1C   INIT    LINE SIZE                                  00870001
*              +1E   UPDATED LINE SIZE                                  00880001
*********************************************************************** 00890000
         MACRO                                                          00900028
&NAME    DOEXIT &P1,&P2,&P3,&P4,&P5,&P6,&P7,&P8,&P9,&P10,&P11,&P12,    *00910028
               &P13,&P14,&P15,&P16,&P17,&P18,&P19,&P20,&C=              00920028
&NAME    IF    &P1,&P2,&P3,&P4,&P5,&P6,&P7,&P8,&P9,&P10,&P11,&P12,&P13,*00930028
               &P14,&P15,&P16,&P17,&P18,&P19,&P20,C=&C                  00940028
           EXIT                                                         00950028
         ENDIF                                                          00960028
         MEND                                                           00970028
.*====================================================================* 00980032
         MACRO                                                          00990018
&LBL     SRST   &R1,&R2          END ADDR REG, START ADDR REG           01000018
.*       CC=1 IF CHAR OF R0(LAT BYTE) IS FOUND &R1 IS SET TO THE ADDR   01010018
.*       CC=2 IF NOT FOUND,REG UNCHANGED                                01020018
.*       CC=3 256 BYTE SERACHED &R2 CHANGED TO PINT THE NEXT 256 BYTE   01030018
         XR     R0,&R1                                                  01040018
         XR     &R1,R0                                                  01050018
         XR     R0,&R1              EXCHANGE R0 AND &R1                 01060018
#&SYSNDX.N  EQU *                                                       01070018
         EX     &R1,#&SYSNDX.EX                                         01080018
         BE     #&SYSNDX.F          FOUND                               01090018
         LA     &R2,1(&R2)                                              01100018
         CR     &R2,R0                                                  01110018
         BH     #&SYSNDX.NF         NOT FOUND                           01120018
         B      #&SYSNDX.N          CONTINUE SEARCH                     01130018
#&SYSNDX.F  EQU *        FOUND                                          01140018
         XR     R0,&R1                                                  01150018
         XR     &R1,R0                                                  01160018
         XR     R0,&R1              EXCHANGE R0 AND &R1                 01170018
         LR     &R1,&R2                                                 01180018
         OR     &R1,&R1             SET CC=1(NON ZERO)                  01190018
         B #&SYSNDX.X                                                   01200018
#&SYSNDX.NF EQU *        NOT FOUND                                      01210018
         XR     R0,&R1                                                  01220018
         XR     &R1,R0                                                  01230018
         XR     R0,&R1              EXCHANGE R0 AND &R1                 01240018
         CR     &R2,&R1             &R2>&R1 CC=2(HIGH)                  01250018
         B #&SYSNDX.X                                                   01260018
#&SYSNDX.EX CLI 0(&R2),0                                                01270018
#&SYSNDX.X  EQU *                                                       01280018
         MEND                                                           01290018
.*====================================================================* 01300002
         MACRO                                                          01310002
         GBLSET               ,        *INT MAX 1S 10 BYTE              01320003
.*                                                                      01330002
    GBLC &UCFSR14                                                       01340002
    GBLC &UCFSR15                                                       01350002
    GBLC &UCFSR0                                                        01360002
    GBLC &UCFSR1                                                        01370002
    GBLC &UCFOPD1                                                       01380003
    GBLC &UCFOPD2                                                       01390003
    GBLC &UCFOPD3                                                       01400003
    GBLC &UCFOPD4                                                       01410003
    GBLC &UCFWRK1                                                       01420003
    GBLC &UCFWRK2                                                       01430003
    GBLC &UCFWRK3                                                       01440003
    GBLC &UCFWRK4                                                       01450003
    GBLC &UCFWRK5                                                       01460003
    GBLC &UCFWRK6                                                       01470003
    GBLC &UCFWRK7                                                       01480003
&UCFSR14 SETC  '12(R13)'      R14                                       01490003
&UCFSR15 SETC  '16(R13)'      R15                                       01500003
&UCFSR0  SETC  '20(R13)'       R0                                       01510003
&UCFSR1  SETC  '24(R13)'       R1                                       01520003
&UCFOPD1 SETC  '28(R13)'      OPEARND SAVE 1                            01530004
&UCFOPD2 SETC  '32(R13)'      OPEARND SAVE 2                            01540004
&UCFOPD3 SETC  '36(R13)'      OPEARND SAVE 3                            01550004
&UCFOPD4 SETC  '40(R13)'      OPEARND SAVE 4                            01560004
&UCFWRK1 SETC  '44(R13)'      WORK1                                     01570003
&UCFWRK2 SETC  '48(R13)'      WORK2                                     01580003
&UCFWRK3 SETC  '52(R13)'      WORK3                                     01590003
&UCFWRK4 SETC  '56(R13)'      WORK4                                     01600003
&UCFWRK5 SETC  '60(R13)'      WORK5                                     01610003
&UCFWRK6 SETC  '64(R13)'      WORK6                                     01620003
&UCFWRK7 SETC  '68(R13)'      WORK7                                     01630003
         MEND  GBLSET                                                   01640003
.*====================================================================* 01650032
.* MACRO NAME : UATOI  _ (GET NUMERIC VALUE)                          * 01660032
.* FORMAT     : LBL UATOI INPA,ENDCHAR=X'00',LEN=                       01670032
.*          (1) INPA   :IINPUT AREA                                     01680032
.*          (2) ENDCHAR:TERMINATION CHAR FOR PARM STRING              * 01690032
.*          (3) LEN    :OPTIONAL MAX LEN PARM                         * 01700032
.* I/O CONDITION                                                        01710032
.*  WORK REG R1,R14,R15   DESTROIED                                     01720032
.*  EXIT CONDITION                                                    * 01730032
.*           R1:BINARY VALUE                                            01740032
.* EXAMPLE                                                            * 01750032
.*     UATOI    INPA                                                    01760032
.*     UATOI    (R2),ENDCHAR=C' '                      *                01770032
.*     UATOI    (R2),LEN=(R0)                          *                01780032
.*====================================================================* 01790032
         MACRO                                                          01800032
&LBL     UATOI  &IN,&ENDCHAR=X'00',&LEN=                                01810032
.********************************************************************** 01820032
&LBL     DS  0H                                                         01830032
.*********                                                              01840032
    GBLC &UCFSR14                                                       01850032
    GBLC &UCFSR15                                                       01860032
    GBLC &UCFSR0                                                        01870032
    GBLC &UCFSR1                                                        01880032
    GBLC &UCFOPD1                                                       01890032
    GBLC &UCFOPD2                                                       01900032
    GBLC &UCFOPD3                                                       01910032
    GBLC &UCFOPD4                                                       01920032
    GBLC &UCFWRK1                                                       01930032
    GBLC &UCFWRK2                                                       01940032
    GBLC &UCFWRK3                                                       01950032
    GBLC &UCFWRK4                                                       01960032
    GBLC &UCFWRK5                                                       01970032
    GBLC &UCFWRK6                                                       01980032
    GBLC &UCFWRK7                                                       01990032
.*********                                                              02000032
&LBL     DS 0H                                                          02010032
         STM R14,R0,&UCFSR14                                            02020032
.*IN   ***                                                              02030032
         AIF ('&IN'(1,1) EQ '(').RIN                                    02040032
         LA R0,&IN                     GET INT VALUE                    02050034
         AGO .COM1                                                      02060032
.RIN     ANOP                                                           02070032
         AIF ('&IN(1)' EQ 'R0').COM1                                    02080032
         LR R0,&IN(1)                 GET INT VALUE                     02090032
.COM1    ANOP                                                           02100032
.*OUT  ***                                                              02110032
         AIF ('&LEN' EQ '').NOLEN                                       02120032
         AIF ('&LEN'(1,1) EQ '(').RLEN                                  02130032
         LA R14,&LEN                  IMMEDIATE VALUE                   02140032
         AGO .COM2                                                      02150032
.RLEN    ANOP                                                           02160032
         AIF ('&LEN(1)' EQ 'R0').REST                                   02170032
         LR R14,&LEN(1)                 GET INT VALUE                   02180032
         AGO .COM2                                                      02190032
.REST    ANOP                                                           02200032
         L R14,&UCFSR0                 ORIGINAL R0 FOR OUT ADDR         02210032
         AGO .COM2                                                      02220032
.NOLEN   ANOP                                                           02230032
         SR R14,R14                   INFINITE                          02240032
         BCTR R14,0                                                     02250032
.COM2    ANOP                                                           02260032
.*PROCESS*                                                              02270032
         SR R1,R1                                                       02280032
         LR R15,R0                    ADDR                              02290034
         SR R0,R0                                                       02300034
         DO FROM=(R14)                                                  02310034
         DOEXIT (CLI,0(R15),E,&ENDCHAR)                                 02320034
         DOEXIT (CLI,0(R15),LT,C'0')                                    02330034
         DOEXIT (CLI,0(R15),GT,C'9')                                    02340034
           IC R0,0(R15)                                                 02350034
           SLL R0,24+4                                                  02360034
           SRL R0,24+4                                                  02370034
           MH R1,=Y(10)                                                 02380032
           AR R1,R0                                                     02390034
           LA R15,1(R15)                                                02400034
         ENDDO                                                          02410032
.*                                                                      02420032
.********                                                               02430032
         LM  R14,R0,&UCFSR14                                            02440032
         MEND     UATOI                                                 02450032
.*====================================================================* 02460003
.* MACRO NAME : UI2Z    CONV INT TO 10 ZONE DIGIT                       02470003
.* FORMAT     : LBL UI2Z &IN,&OUT,&LEN=                                 02480003
.*          (1) IN     :INT TYPE  ADDR OR (RX) VALUE      *             02490003
.*          (2) OUT    :OUT AREA ADDR(LAST BYTE CONTAIN SIGN)           02500003
.*                      ADDR OR (RX) FORMAT                             02510003
.*                      IF OMMITTED R1 POINT ZONE ADDR ON SAVE AREA     02520003
.*          (3) LEN    :OUT AREA LEN   EQU ONLY                         02530003
.* I/O CONDITION                                                        02540003
.*  ALL REG PRESERVED                                                   02550003
.*    EXCEPT R1:ADDR OF ZONE IF OUT PARM NOT SPECIFIED                  02560003
.*  EXIT CONDITION                                                    * 02570003
.*     NONE                                                             02580003
.* EXAMPLE                                                            * 02590003
.*     UI2Z     (R1),OUTA                                               02600003
.*     UI2Z     INPA,(R3),LEN=8                                         02610003
.*     UI2Z     INPA                                                    02620003
.*====================================================================* 02630003
         MACRO                                                          02640003
&LBL     UI2Z &IN,&OUT,&LEN=           *INT MAX 1S 10 BYTE              02650003
.*********                                                              02660003
    GBLC &UCFSR14                                                       02670003
    GBLC &UCFSR15                                                       02680003
    GBLC &UCFSR0                                                        02690003
    GBLC &UCFSR1                                                        02700003
    GBLC &UCFOPD1                                                       02710003
    GBLC &UCFOPD2                                                       02720003
    GBLC &UCFOPD3                                                       02730003
    GBLC &UCFOPD4                                                       02740003
    GBLC &UCFWRK1                                                       02750003
    GBLC &UCFWRK2                                                       02760003
    GBLC &UCFWRK3                                                       02770003
    GBLC &UCFWRK4                                                       02780003
    GBLC &UCFWRK5                                                       02790003
    GBLC &UCFWRK6                                                       02800003
    GBLC &UCFWRK7                                                       02810003
.*********                                                              02820003
         AIF ('&LEN' NE '').LENOK                                       02830003
         MNOTE 8,'UI2Z-01:LEN= PARM(OUTPUT AREA LEN) IS MISSING'        02840003
         MEXIT                                                          02850003
.LENOK   ANOP                                                           02860003
&LBL     DS 0H                                                          02870003
         STM R14,R0,&UCFSR14                                            02880003
.*IN   ***                                                              02890003
         AIF ('&IN'(1,1) EQ '(').RIN                                    02900003
         ICM R0,B'1111',&IN                     GET INT VALUE           02910034
         AGO .COM1                                                      02920003
.RIN     ANOP                                                           02930003
         AIF ('&IN(1)' EQ 'R0').COM1                                    02940003
         LR R0,&IN(1)                 GET INT VALUE                     02950003
.COM1    ANOP                                                           02960003
.*OUT  ***                                                              02970003
         AIF ('&OUT' EQ '').NOOUT1                                      02980003
         AIF ('&OUT'(1,1) EQ '(').ROUT                                  02990003
         LA R14,&OUT                    GET OUT ADDR VALUE              03000003
         AGO .COM2                                                      03010003
.ROUT    ANOP                                                           03020003
         AIF ('&OUT(1)' EQ 'R0').REST                                   03030003
         LR R14,&OUT(1)                 GET INT VALUE                   03040003
         AGO .COM2                                                      03050003
.REST    ANOP                                                           03060003
         L R14,&UCFSR0                 ORIGINAL R0 FOR OUT ADDR         03070003
.COM2    ANOP                                                           03080003
         AGO .COM3                                                      03090003
.NOOUT1  ANOP                                                           03100003
         LA R14,&UCFWRK3               ZONE WORK                        03110003
.COM3    ANOP                                                           03120003
.*PROCESS*                                                              03130003
         LA R15,&UCFWRK1              PACK WORK                         03140003
         CVD R0,0(R15)                                                  03150003
.*                                                                      03160003
         UNPK 0(&LEN,R14),0(8,R15)       VALUE                          03170003
         LTR R0,R0                                                      03180003
.*       BM UI2Z_&SYSNDX.2                                   D#@@@@2    03190003
         BM #&SYSNDX.#2                                      A#@@@@2    03200003
.*                                                                      03210003
         OI &LEN-1(R14),X'F0'                                           03220003
.*                                                                      03230003
.*UI2Z_&SYSNDX.2 EQU *                                        D#@@@@2   03240003
#&SYSNDX.#2 EQU *                                             A#@@@@2   03250003
.********                                                               03260003
         LM  R14,R0,&UCFSR14                                            03270003
         MEND  UI2Z                                                     03280003
.*====================================================================* 03290003
.*ULN#00000 980511 P01040 CREATED                                     * 03300003
.*====================================================================* 03310003
.* MACRO NAME : UI2ZE   STANDARD INTEGER EDIT (-Z,ZZZ,ZZZ,ZZ9)          03320003
.*                      FOR MINUS '-' IS SET AT BEFORE FIRST DIGIT      03330003
.* FORMAT     : LBL UI2ZE &IN,&OUT,&LEN=14                              03340003
.*          (1) IN     :INT TYPE  ADDR OR (RX) VALUE      *             03350003
.*          (2) OUT    :OUT AREA ADDR(LAST BYTE CONTAIN SIGN)           03360003
.*                      ADDR OR (RX) FORMAT                             03370003
.*                      IF OMMITTED R1 POINT AREA ON SAVE AREA          03380003
.*                      OF LENGTH SPECIFIED BY &LEN                     03390003
.*          (3) LEN    :OUT AREA LEN   EQU ONLY (MAX IS 14)             03400003
.*                      COPY LAST N BYTE  TO OUT AREA                   03410003
.* I/O CONDITION                                                        03420003
.*  ALL REG PRESERVED                                                   03430003
.*    EXCEPT R1:ADDR OF ZONE IF OUT PARM NOT SPECIFIED                  03440003
.*  EXIT CONDITION                                                    * 03450003
.*     NONE                                                             03460003
.* EXAMPLE                                                            * 03470003
.*     UI2Z     (R1),OUTA                                               03480003
.*     UI2Z     INPA,(R3),LEN=8                                         03490003
.*     UI2Z     INPA                                                    03500003
.*====================================================================* 03510003
         MACRO                                                          03520003
&LBL     UI2ZE &IN,&OUT,&LEN=14                                         03530003
.*********                                                              03540003
    GBLC &UCFSR14                                                       03550003
    GBLC &UCFSR15                                                       03560003
    GBLC &UCFSR0                                                        03570003
    GBLC &UCFSR1                                                        03580003
    GBLC &UCFOPD1                                                       03590003
    GBLC &UCFOPD2                                                       03600003
    GBLC &UCFOPD3                                                       03610003
    GBLC &UCFOPD4                                                       03620003
    GBLC &UCFWRK1                                                       03630003
    GBLC &UCFWRK2                                                       03640003
    GBLC &UCFWRK3                                                       03650003
    GBLC &UCFWRK4                                                       03660003
    GBLC &UCFWRK5                                                       03670003
    GBLC &UCFWRK6                                                       03680003
    GBLC &UCFWRK7                                                       03690003
         LCLC &MAXLEN,&CPYLEN                                   A#@@@@2 03700003
.*********                                                              03710003
&MAXLEN  SETC '15'                    OUTPUT MAX LEN                    03720003
&CPYLEN  SETC '&LEN'                     OUTPUT LEN                     03730003
.*********                                                              03740003
&LBL     DS 0H                                                          03750003
         STM R14,R1,&UCFSR14                                            03760003
.*IN   ***                                                              03770003
         AIF ('&IN'(1,1) EQ '(').RIN                                    03780003
         L R0,&IN                     GET INT VALUE                     03790003
         AGO .COM1                                                      03800003
.RIN     ANOP                                                           03810003
         AIF ('&IN(1)' EQ 'R0').COM1                                    03820003
         LR R0,&IN(1)                 GET INT VALUE                     03830003
.COM1    ANOP                                                           03840003
.*OUT  ***                                                              03850003
         AIF ('&OUT' EQ '').NOOUT1                                      03860003
         AIF ('&OUT'(1,1) EQ '(').ROUT                                  03870003
         LA R14,&OUT                    GET OUT ADDR VALUE              03880003
         AGO .COM2                                                      03890003
.ROUT    ANOP                                                           03900003
         AIF ('&OUT(1)' EQ 'R0').REST                                   03910003
         LR R14,&OUT(1)                 GET INT VALUE                   03920003
         AGO .COM2                                                      03930003
.REST    ANOP                                                           03940003
         L R14,&UCFSR0                 ORIGINAL R0 FOR OUT ADDR         03950003
.COM2    ANOP                                                           03960003
.NOOUT1  ANOP                                                           03970003
.*PROCESS*                                                              03980003
         LA R15,&UCFWRK1              PACK WORK,WRK1 AND WRK2           03990003
         CVD R0,0(R15)                                                  04000003
.*SET EDIT PATERN TO WRK3-WRK7(5*4=20 BYTE)                             04010003
.*SIGNIFICANT STARTER X'21' SHOULD NOT BE SET FOR EDMK SET R1           04020003
.*R1 SET WHEN DIGIT SELECTED AT THE STATUS SIGNIFICANT INDICATER OFF    04030003
         LA R15,&UCFWRK3              PACK WORK,WRK1 AND WRK2           04040003
         MVC 0(&MAXLEN,R15),=X'4020206B2020206B2020206B202020'          04050003
         EDMK 0(&MAXLEN,R15),2+&UCFWRK1  11 DIGIT=PL6=15BYTE OUT        04060003
.*       BP  UI2ZE_&SYSNDX.1        LAST FIELD >0               D#@@@@2 04070003
         BP  #&SYSNDX.#1            LAST FIELD >0               A#@@@@2 04080003
.*       BM  UI2ZE_&SYSNDX.M        LAST FIELD <0               D#@@@@2 04090003
         BM  #&SYSNDX.#M            LAST FIELD <0               A#@@@@2 04100003
         MVI &MAXLEN-1(R15),C'0'    FORCE ZERO                          04110003
.*       B   UI2ZE_&SYSNDX.1        LAST FIELD <0               D#@@@@2 04120003
         B   #&SYSNDX.#1       LAST FIELD <0                    A#@@@@2 04130003
.*UI2ZE_&SYSNDX.M EQU *                                         D#@@@@2 04140003
#&SYSNDX.#M EQU *                                               A#@@@@2 04150003
         BCTR R1,0                                                      04160003
         MVI 0(R1),C'-'                MINUS SIGN                       04170003
.*UI2ZE_&SYSNDX.1 EQU *                                         D#@@@@2 04180003
#&SYSNDX.#1 EQU *                                               A#@@@@2 04190003
         AIF ('&OUT' EQ '').NOOUT2                                      04200003
.*                                                                      04210003
         MVC 0(&CPYLEN,R14),&MAXLEN-&CPYLEN+&UCFWRK3                    04220003
.*                                                                      04230003
         AGO .COM3                                                      04240003
.NOOUT2  ANOP                                                           04250003
         LA R15,&MAXLEN-&CPYLEN.(R15) ON SAVE AREA                      04260003
         ST R15,&UCFSR1               RETURN R1                         04270003
.COM3    ANOP                                                           04280003
.********                                                               04290003
         LM  R14,R1,&UCFSR14                                            04300003
         MEND  UI2ZE                                                    04310003
.*====================================================================* 04320003
.*ULN#00000 980414 P01040 CREATED                                     * 04330003
.*====================================================================* 04340003
.* MACRO NAME : UI2X    CONV INT TO 8 HEX DIGIT                         04350003
.* FORMAT     : LBL UI2X &IN,&OUT,&LEN=                                 04360003
.*          (1) IN     :UINT TYPE  ADDR OR (RX) TYPE        *           04370003
.*                     :UINT  :WORD AS UNSIGNED             *           04380003
.*                     :SHORT :HALF WORD AS SIGNED          *           04390003
.*                     :USHORT:HALF WORD AS UNSIGNED          *         04400003
.*          (2) OUT    :OUT AREA ADDR                                   04410003
.*                      ADDR OR (RX) FORMAT                             04420003
.*                      IF OMMITTED R1 POINT HEX ADDR ON SAVE AREA      04430003
.*          (3) LEN    :LENGTH TO BE MOVED(LOWER BYTE)                  04440003
.*                      CONSTANT OR EQU FORMAT                          04450003
.*                      DEFAULT=8                                       04460003
.* I/O CONDITION                                                        04470003
.*  ALL REG PRESERVED EXCEP R1 FOR IF NO OUT AREA SPECIFIED             04480003
.*  EXIT CONDITION                                                    * 04490003
.*     NONE                                                             04500003
.* EXAMPLE                                                            * 04510003
.*     UI2X     (R1),OUTA                                               04520003
.*     UI2X     INPA,(R3)                                               04530003
.*     UI2X     (R0)                                                    04540003
.*====================================================================* 04550003
         MACRO                                                          04560003
&LBL     UI2X &IN,&OUT,&LEN=8                                           04570003
.*********                                                              04580003
    GBLC &UCFSR14                                                       04590003
    GBLC &UCFSR15                                                       04600003
    GBLC &UCFSR0                                                        04610003
    GBLC &UCFSR1                                                        04620003
    GBLC &UCFOPD1                                                       04630003
    GBLC &UCFOPD2                                                       04640003
    GBLC &UCFOPD3                                                       04650003
    GBLC &UCFOPD4                                                       04660003
    GBLC &UCFWRK1                                                       04670003
    GBLC &UCFWRK2                                                       04680003
    GBLC &UCFWRK3                                                       04690003
    GBLC &UCFWRK4                                                       04700003
    GBLC &UCFWRK5                                                       04710003
    GBLC &UCFWRK6                                                       04720003
    GBLC &UCFWRK7                                                       04730003
.*********                                                              04740003
.********************************************************************** 04750003
&LBL     DS 0H                                                          04760003
         STM R14,R0,&UCFSR14                                            04770003
.*IN   ***                                                              04780003
.*       UCFGOPD ADDRVAL,SAVE1,&IN   SAVE INP VALUE TO SAVE+28 D#0000   04790003
         ST &IN(1),&UCFOPD1          SAVE OPERAND TO SAVEAREA  A#0000   04800003
.*OUT  ***                                                              04810003
         AIF ('&OUT' EQ '').NOOUT1                                      04820003
.*       UCFGOPD ADDR,SAVE2,&OUT      GET ADDR VALUE TO SAVE+28 D#0000  04830003
         LA R0,&OUT                        GET OPD ADDR         A#0000  04840003
         ST R0,&UCFOPD2               SAVE OPERAND TO SAVEAREA  A#0000  04850003
.NOOUT1  ANOP                                                           04860003
.*PROCESS*                                                              04870003
         LA R15,&UCFOPD1               INP VALUE ADDR                   04880003
         LA R14,&UCFWRK1                UNPK AREA                       04890003
         UNPK 0(9,R14),0(5,R15)                                         04900003
.*       L R15,UI2X_&SYSNDX.V          INTF CSECT ADDR  D#0000  D#@@@@2 04910003
.*       L R15,#&SYSNDX.#V         INTF CSECT ADDR      D#0000  A#@@@@2 04920003
.*       L R15,&UCFPGMI(1)._TBLTOP(R15)      TBL HDR    D#0000          04930003
.*       L R15,(6-1)*4(R15)      ABLE TO CONV TO HEX DIGIT  D#0000      04940003
         L R15,#&SYSNDX.TRT             TR TABLE TO CONV TO HEX DIGIT   04950003
         TR 0(8,R14),0(R15)                                             04960003
.*                                                                      04970003
.*       B UI2X_&SYSNDX.X EQU *                               D#@@@@2   04980003
         B #&SYSNDX.#X EQU *                                  A#@@@@2   04990003
#&SYSNDX.TRT DC A(*+4-X'F0') TRANSLATE BIN TO HEX DIGIT A#0000          05000003
         DC C'0123456789ABCDEF' F0-->F9,FA-->FF TO C'0'-->C'F' A#0000   05010003
#&SYSNDX.#X EQU *                                               A#@@@@2 05020003
.*                                                                      05030003
         AIF ('&OUT' EQ '').NOOUT2                                      05040003
         L R15,&UCFOPD2                                                 05050003
         MVC 0(&LEN,R15),8-&LEN.(R14)                                   05060003
         AGO .COM3                                                      05070003
.NOOUT2  ANOP                                                           05080003
         LR R1,R14                     OUTPUT HEX DIGIT FIELD ADDR      05090003
.COM3    ANOP                                                           05100003
         LM  R14,R0,&UCFSR14                                            05110003
.*       UCFMEND                                                        05120004
         MEND   *UI2X                                                   05130003
.*+++++===============================================================* 05140017
.*====================================================================* 05150017
.* MACRO NAME : UMEMCHR                                               * 05160017
.*             (MEMCHR FUNCTION OF LANGUAGE C)                        * 05170017
.*              SEARCH A CHAR ON AREA OF SPECIFIED LENGTH             * 05180017
.* FORMAT     : LBL UMEMCHR ADDR,CHAR,LEN                             * 05190017
.*          (1) ADDR   :SEARCH AREA ADDR;   (RX) OR AREA-NAME         * 05200017
.*          (2) CHAR   :SEARCH CHAR;LITERAL/EQU OR (RX)               * 05210017
.*          (3) LEN    :SREARCH AREA LEN;  LITERAL/EQU OR (RX)        * 05220017
.* EXIT CONDITION                                                    *  05230017
.*    ALL REG IS PRESERVED EXCEPT R1                                    05240017
.*    R1          :FOUND ADDR,0 IF NOT FOUND                            05250017
.* EXAMPLE                                                            * 05260017
.*     UMEMCHR WKAREA,C' ',256                                        * 05270017
.*     UMEMCHR (R3),SRCHCHAR,(R2)                                     * 05280017
.*     UMEMCHR STRING,X'0E',EQUASZ                                    * 05290017
.*====================================================================* 05300017
         MACRO                                                          05310017
&L       UMEMCHR  &ADDR,&CHAR,&LEN                                      05320017
.*********                                                              05330017
    GBLC &UCFSR14                                                       05340017
    GBLC &UCFSR15                                                       05350017
    GBLC &UCFSR0                                                        05360017
    GBLC &UCFSR1                                                        05370017
    GBLC &UCFOPD1                                                       05380017
    GBLC &UCFOPD2                                                       05390017
    GBLC &UCFOPD3                                                       05400017
    GBLC &UCFOPD4                                                       05410017
    GBLC &UCFWRK1                                                       05420017
    GBLC &UCFWRK2                                                       05430017
    GBLC &UCFWRK3                                                       05440017
    GBLC &UCFWRK4                                                       05450017
    GBLC &UCFWRK5                                                       05460017
    GBLC &UCFWRK6                                                       05470017
    GBLC &UCFWRK7                                                       05480017
.*********                                                              05490017
&L       DS 0H                                                          05500017
         STM R15,R0,&UCFSR15                                            05510017
.**ADDR***                                                              05520017
.*       UCFGOPD ADDR,SAVE1,&ADDR     GET ADDR VALUE                    05530017
         AIF ('&ADDR'(1,1) EQ '(').RADDR                                05540045
         LA R0,&ADDR                                                    05550045
         AGO .SVADDR                                                    05560045
.RADDR   ANOP                                                           05570045
         LR R0,&ADDR(1)                    GET OPD ADDR         A#0000  05580018
.SVADDR  ANOP                                                           05590045
         ST R0,&UCFOPD1               SAVE OPERAND TO SAVEAREA  A#0000  05600017
.**LEN****                                                              05610017
.*       UCFGOPD EQU,SAVE2,&LEN       GET LEN  VALUE                    05620017
         ST &LEN(1),&UCFOPD2          SAVE OPERAND TO SAVEAREA  A#0000  05630017
.**CHAR***                                                              05640017
.*       UCFGOPD EQU1,R0,&CHAR        GET CHAR VALUE TO R0              05650017
         LA R0,&CHAR                       GET OPD ADDR         A#0000  05660017
.*********                                                              05670017
         UMEMCHR# &UCFOPD1,(R0),&UCFOPD2      SEARCH     R#@@@@2        05680017
.*                                                                      05690017
         LM  R15,R0,&UCFSR15                                            05700017
.*       UCFMEND                                                        05710018
         MEND  * MEMCHAR                                                05720017
.*====================================================================* 05730017
.* MACRO NAME : UMEMCHR_                                              * 05740017
.*              SUB OF UMEMCHR                                        * 05750017
.*              SEARCH A CHAR ON AREA OF SPECIFIED LENGTH             * 05760017
.* FORMAT     :     UMEMCHR ADDR,CHAR,LEN                               05770017
.*          (1) ADDR   :SEARCH AREA ADDR;   AREA-NAME                   05780017
.*          (2) CHAR   :SREARCH CHAR    ;   AREA-NAME ,(RX)           * 05790017
.*          (3) LEN    :SREARCH AREA LEN;   AREA-NAME ,(RX)           * 05800017
.* EXIT CONDITION                                                    *  05810017
.*    R15 :WORK REG                                                     05820017
.*    R1  :FOUND ADDR,0 IF NOT FOUND                                    05830017
.* EXAMPLE                                                            * 05840017
.*     UMEMCHR_  &UCFOPD1,(R0),&UCFOPD2                                 05850017
.*     UMEMCHR_  &UCFOPD1,&UCFOPD2,(R1)                                 05860017
.*====================================================================* 05870017
         MACRO                                                          05880017
         UMEMCHR# &ADDR,&CHAR,&LEN                    R#@@@@2           05890017
.*********                                                              05900017
    GBLC &UCFSR14                                                       05910017
    GBLC &UCFSR15                                                       05920017
    GBLC &UCFSR0                                                        05930017
    GBLC &UCFSR1                                                        05940017
    GBLC &UCFOPD1                                                       05950017
    GBLC &UCFOPD2                                                       05960017
    GBLC &UCFOPD3                                                       05970017
    GBLC &UCFOPD4                                                       05980017
    GBLC &UCFWRK1                                                       05990017
    GBLC &UCFWRK2                                                       06000017
    GBLC &UCFWRK3                                                       06010017
    GBLC &UCFWRK4                                                       06020017
    GBLC &UCFWRK5                                                       06030017
    GBLC &UCFWRK6                                                       06040017
    GBLC &UCFWRK7                                                       06050017
.*********                                                              06060017
.* UMEMCHR_ * START *                                                   06070017
.* CHAR                                                                 06080017
         AIF ('&CHAR'(1,1) NE '(').FLDC                                 06090017
         AIF ('&CHAR(1)' EQ 'R0').COMC                                  06100017
         LR R0,&CHAR(1)         SEARCH CHAR                             06110017
         AGO .COMC                                                      06120017
.FLDC    ANOP                                                           06130017
         L R0,&CHAR             SEARCH CHAR                             06140017
.COMC    ANOP                                                           06150017
.* ADDR                                                                 06160017
         AIF ('&ADDR'(1,1) NE '(').FLDA                                 06170017
         AIF ('&ADDR(1)' EQ 'R15').COMA                                 06180017
         AIF ('&ADDR(1)' NE 'R0').ADDROK                                06190017
         MNOTE 8,'UMEMCHR_-02:R0 IS NOT VALID FOR ADDR PARM'            06200017
         MEXIT                                                          06210017
.ADDROK  ANOP                                                           06220017
         LR R15,&ADDR(1)                                                06230017
         AGO .COMA                                                      06240017
.FLDA    ANOP                                                           06250017
         L R15,&ADDR             START ADDR                             06260017
.COMA    ANOP                                                           06270017
.*                                                                      06280017
         AIF ('&LEN'(1,1) EQ '(').REGLEN                                06290017
         L R1,&LEN               LEN                                    06300017
         AGO .SRCH                                                      06310017
.REGLEN  ANOP                                                           06320017
         AIF ('&LEN(1)' NE 'R15' AND '&LEN(1)' NE 'R0').REGOK           06330017
         MNOTE 8,'UMEMCHR_-01:R0/R15 IS NOT VALID FOR LEN PARM'         06340017
         MEXIT                                                          06350017
.REGOK   ANOP                                                           06360017
         AIF ('&LEN(1)' EQ 'R1').SRCH                                   06370017
         LR R1,&LEN                                                     06380017
.*                                                                      06390017
.SRCH    ANOP                                                           06400017
         AR R1,R15                    END ADDR                          06410017
.*UMEMCHR_&SYSNDX.7 EQU *                RETRY LOOP            D#@@@@2  06420017
#&SYSNDX.7 EQU *                         RETRY LOOP            A#@@@@2  06430017
         SRST R1,R15                     END ADDR,START ADDR            06440017
.*CC=1 FOUND;R1:FOUND ADDR,R2:NOT CHANGED                               06450017
.*       BC 4,UMEMCHR_&SYSNDX.5 CC=1,FOUND(R1:MATCH ADDR,R2:SAMED#@@@@2 06460017
         BC 4,#&SYSNDX.5 CC=1,FOUND(R1:MATCH ADDR,R2:SAME       A#@@@@2 06470017
.*CC=2 NOT FOUND;R1/R2 NOT CHANGED                                      06480017
.*       BC 2,UMEMCHR_&SYSNDX.6   CC=2,NOT FOUND(R1,R2:SAME)    D#@@@@2 06490017
         BC 2,#&SYSNDX.6          CC=2,NOT FOUND(R1,R2:SAME)    A#@@@@2 06500017
.*CC=3 SEARCHED 256;R2:CHANGED TO NEXT START ADDR,R1:NOT CHANGED        06510017
.*       B UMEMCHR_&SYSNDX.7 CC=3,RTRY BY NEW ADD(R1:SAME,R2:NEWD#@@@@2 06520017
         B #&SYSNDX.7 CC=3,RTRY BY NEW ADD(R1:SAME,R2:NEW)      A#@@@@2 06530017
.*UMEMCHR_&SYSNDX.6 EQU *               NOT FOUND              D#@@@@2  06540017
#&SYSNDX.6 EQU *                        NOT FOUND              A#@@@@2  06550017
         SR R1,R1                        NOT FOUND ID                   06560017
.*UMEMCHR_&SYSNDX.5 EQU *               FOUND                  D#@@@@2  06570017
#&SYSNDX.5 EQU *                        FOUND                  A#@@@@2  06580017
** UMEMCHR_ * END *                                                     06590017
         MEND   MEMCHR_                                                 06600017
.*====================================================================* 06610017
.*====================================================================* 06620034
.* MACRO NAME  = GET DATE ZONE(YYMMDD) SEIREKI                          06630003
.* FORMAT     : NAME UDATE AREA=,TODAY=,INPUT=,TBL=                     06640003
.* -OPERAND    - &NAME    : LABEL FOR MACRO START AND DATE TABLE        06650003
.*             - &AREA    : OUTPUT 6 BYTE FIELD                         06660003
.*             - &TODAY   : Y:CALC OF TODAY                             06670003
.*             -          : N:CALC OF &AREA FIELD(..YYDDD..... FMT)     06680003
.*             -          :   IF INPUT=J XL6'..YYDDD.....' FMT          06690003
.*             -          :   IF INPUT=S XL6'..YYMMDD....' FMT          06700003
.*             - &INPUT   : J:CONV FROM YYDDD TO YYMMDD                 06710003
.*             -          : S:CONV FROM YYMMDD TO YYDDD                 06720003
.*             - &TBL     : Y:GENERATE DATE TABLE FOR EACH MACRO        06730003
.*             -          : N:GENERATE DATE TABLE ONLY ONCE             06740003
.* -EXANPLE    - (1) UDATE        , SET 00YYDDDF TO R1                  06750003
.*             - (2) UDATE WKDATE                                     * 06760003
.*             - (3) UDATE (R2),TODAY=N                                 06770003
.*             - (4) UDATE (R2),TODAY=N,INPUT=S                         06780003
.* I/O CONDITION                                                        06790003
.*  REGISTER NOTATION                                                 * 06800003
.*           R.C     - R15    0:NORMAL                                  06810003
.*                            4:ERR  (ONLY WHEN TODAY = N)              06820003
.*           DESTROY - R14 0:HEINEN                                     06830003
.*                         4:URUUDOSHI                                  06840003
.*                   - R0 :00YYMMDD  (ONLY WHEN INPUT = J)              06850003
.*                   - R1 :00YYDDDF OF TODAY                            06860003
.*           RETURN  - NONE                                           * 06870003
.*     IF NO TOD PARM   R1(HHMMSSTH)  R0(00YYDDDF):CURRENT DAY          06880003
.*     IF TOD PARM      R1(HHMMSSTH)  R0(DDDDDDDF):BACK DAY COUNT       06890003
.* EXAMPLE                                                            * 06900003
.*====================================================================* 06910003
         MACRO                                                          06920003
&NAME    UDATE &AREA,&TODAY=Y,&INPUT=J,&TBL=N                           06930003
.********************************************************************** 06940003
         LCLC  &IX                     FOR LABEL NAMING                 06950003
         LCLC  &TB                                              A#@@@@2 06960003
                                                                        06970003
         GBLB  &UDATEGB                FOR TABLE CREATION SW            06980003
         GBLC  &UDATEGC                FOR TABLE CREATION LABEL         06990003
&IX      SETC  '&SYSNDX'               FOR LABEL NAMING                 07000003
.*                                                                      07010003
         AIF   (NOT &UDATEGB).FIRST                                     07020003
         AIF   ('&TBL' EQ 'N').SECNO                                    07030003
.FIRST   ANOP                                                           07040003
         AIF   ('&NAME' NE '').NAMEOK                                   07050003
.*&TB    SETC  'UDT'.'&IX'            TABLE LABEL          D#@@@@2      07060004
&TB      SETC  'UD'.'&IX'             TABLE LABEL          A#@@@@2      07070004
         AGO   .TOG00                                                   07080004
.NAMEOK  ANOP                                                           07090004
&TB      SETC  '&NAME'                 TABLE LABEL FROM MACRO LABEL     07100004
.TOG00   ANOP                                                           07110004
         AIF   (&UDATEGB).NOTFST                                        07120004
&UDATEGC SETC  '&TB'                   TABLE LABEL FROM MACRO LABEL     07130004
.NOTFST  ANOP                                                           07140004
         AGO   .TOG0                                                    07150004
.*                                                                      07160004
.SECNO   ANOP                          NO TBL CREATION                  07170004
&TB      SETC  '&UDATEGC'              TABLE LABEL FROM MACRO LABEL     07180004
.TOG0    ANOP                                                           07190004
**                                     ***** START MACRO UDATE    ***** 07200004
&NAME    DS    0H                                                       07210004
         AIF   ('&AREA' NE '').OUTAREA                       A#@@@@     07220004
         AIF   ('&TODAY' NE 'Y').ERAREA                      A#@@@@     07230004
         L    R1,16                  GET ADDR OF CVT         A#@@@@     07240004
         L    R1,X'38'(R1)  00YYDDDF CURRENT DATE IN PACKED  A#@@@@     07250004
         MEXIT                                               A#@@@@     07260004
.*.ERRAREA ANOP                        REG TYPE AREA         A#@@@@     07270004
.ERAREA  ANOP                  REG TYPE AREA        A#@@@@      D#@@@@1 07280004
         MNOTE 8,'** MISSING OUTPUT AREA FOR TODAY="N" **'   A#@@@@     07290004
         MEXIT                                               A#@@@@     07300004
.OUTAREA ANOP                          REG TYPE AREA         A#@@@@     07310004
         AIF   ('&AREA'(1,1) NE '(').SAREA S TYPE                       07320004
         LR    R14,&AREA(1)            ADDR AREA FIELD                  07330004
         AGO   .TOG1                                                    07340004
.SAREA   ANOP                          REG TYPE AREA                    07350004
         LA    R14,&AREA               ADDR AREA FIELD                  07360004
.TOG1    ANOP                                                           07370004
         AIF   ('&TODAY' NE 'Y').INPDAY NOT TODAY                       07380004
         AIF   ('&INPUT' EQ 'J').INPOK  NOT TODAY                       07390004
         MNOTE 8,'** UDATE INPUT OPD MUST BE "J" WHEN TODAY ="Y" **'    07400004
.INPOK   ANOP                                                           07410004
         L    R15,16                   GET ADDR OF CVT                  07420004
         L    R15,X'38'(R15)  00YYDDDF CURRENT DATE IN PACKED DECIMAL   07430004
         AGO   .TOG2                                                    07440004
.INPDAY  ANOP                                                           07450004
         MVI  0(R14),0                 CONFIRM TOP BYTE 0               07460034
         AIF   ('&INPUT' NE 'J').YMD1  YMD TO YYDDD                     07470004
         OI   3(R14),X'0F'             CONFIRM SIGN                     07480004
.YMD1    ANOP                                                           07490004
         L    R15,0(R14)               INPUT JULIAN DATE                07500004
.********************************************************************** 07510004
.TOG2    ANOP                                                           07520004
         XC    0(6,R14),0(R14)         CLEAR AREA                       07530004
         MVI   3(R14),X'0C'            ADD SIGN BIT   0000000C0000      07540004
         STCM  R15,B'0100',2(R14)      GET YY*10      0000YY0C0000      07550004
         CLI   2(R14),X'00'            CHK YY             --            07560004
         BE    UDT&IX.D                100 NEN NOT URUUDOSHI            07570004
         DP    0(4,R14),&TB.40         /40(4YEAR)     SSSC0R0C0000      07580004
         CLI   2(R14),X'00'                               --            07590004
         BZ    UDT&IX.1                YES URUU EVERY 4 YEAR            07600004
UDT&IX.D EQU   *                       HEINEN                           07610004
         AIF   ('&TODAY' EQ 'Y').INPH   NOT TODAY                       07620004
         LA    R1,&TB.HE               YEAR END DAY#                    07630004
.INPH    ANOP                                                           07640004
         LA    R0,&TB.H                MONTH TBL TOP ADDR               07650004
         ST    R15,0(R14)              STORE R15 TO WRK                 07660004
         B     UDT&IX.2                COMMON FOR URUU/HEINEN           07670004
UDT&IX.1 EQU   *                       URUDOSI                          07680004
         AIF   ('&TODAY' EQ 'Y').INPX   NOT TODAY                       07690004
         LA    R1,&TB.UE               YEAR END DAY#                    07700004
.INPX    ANOP                                                           07710004
         LA    R0,&TB.U                MONTH TBL TOP ADDR               07720004
         ST    R15,0(R14)              +++++ STORE R15 TO WRK           07730004
         MVI   0(R14),X'F0'            +++++ URUU --> TOP BYTE X'F0'    07740034
         L     R15,0(R14)              +++++ STORE DATE TO R15          07750004
UDT&IX.2 EQU   *                       AFTER CHECK URUU                 07760004
         AIF   ('&TODAY' EQ 'Y').INPU   NOT TODAY                       07770004
         AIF   ('&INPUT' NE 'J').YMD2  YMD TO YYDDD                     07780004
         CP    2(2,R14),&TB.0          CHK ZERO           ----          07790004
         BE    UDT&IX.E                SPECIFICATION ERR                07800004
         CP    2(2,R14),0(2,R1)        CHK YEAR END       ----          07810004
         BH    UDT&IX.E                OVER YEAR END                    07820004
         AGO   .INPU                                                    07830004
.*                                                                      07840004
.* CONV YYMMDD TO YYDDD                                                 07850004
.*                                                                      07860004
.YMD2    ANOP                          00YYMMDD0000                     07870004
.* DD CHK                                                               07880004
         CLI   3(R14),X'00'            CHK DD IS ZERO  00YYMMDD0000     07890004
         BE    UDT&IX.E                SPECIFICATION ERR                07900004
         NI    3(R14),X'0F'            CHK XD          00YYMM0D0000     07910004
         CLI   3(R14),X'09'            CHK XD IS X0 - X9                07920004
         BH    UDT&IX.E                SPECIFICATION ERR                07930004
         STC   R15,3(R14)              00YYMMDD0000                     07940004
         NI    3(R14),X'F0'            CHK DX          00YYMMD00000     07950004
         CLI   3(R14),X'30'            CHK DX    0X - 3X                07960004
         BH    UDT&IX.E                SPECIFICATION ERR                07970004
.* MM CHK                                                               07980004
         CLI   2(R14),X'00'            CHK MM IS ZERO,00YYMMD00000      07990004
         BE    UDT&IX.E                SPECIFICATION ERR                08000004
         TM    2(R14),X'E0'            CHK MM(1X OR 0X)                 08010004
         BNZ   UDT&IX.E                SPECIFICATION ERR                08020004
         MVC   5(1,R14),2(R14)         00YYMMD000MM                     08030004
         NI    5(R14),X'0F'            00YYMMD0000M                     08040004
         CLI   5(R14),X'09'            CHK MM (01 TO 09)                08050004
         BH    UDT&IX.E                SPECIFICATION ERR                08060004
.* GET MM IN BINALY                                                     08070004
         LH    R1,4(R14)               GET .M                           08080004
         TM    2(R14),X'10'            CHK MM(1X OR 0X)                 08090004
         BNO   UDT&IX.K                MM IS 01-09                      08100004
         LA    R1,10(R1)               MM IN BINALY                     08110004
UDT&IX.K EQU   *                                                        08120004
         BCTR  R1,0                    MM TBL OFFSET                    08130004
         BCTR  R1,0                    MM-1   OFFSET                    08140004
         SLL   R1,1                    DAY TBL OFFSET                   08150004
         AR    R1,R0                   MM - 1  MONTH START DAY ADDR     08160004
         ZAP   4(2,R14),0(2,R1)        00------DDDC                     08170004
         MVI   3(R14),X'0C'            00----0CDDDC                     08180004
         STC   R15,1(R14)              00DD--0CDDDC                     08190004
         MVO   2(2,R14),0(2,R14)       00--0DDCDDDC                     08200004
         AP    4(2,R14),2(2,R14)       00------DDDC                     08210004
         LA    R1,2(R1)                MONTH END TBL ADDR               08220004
         CP    4(2,R14),0(2,R1)                ----                     08230004
         BH    UDT&IX.E                SPECIFICATION ERR                08240004
         ZAP   2(2,R14),4(2,R14)       00--DDDC---C                     08250004
         OI    3(R14),X'0F'            00--DDDF---C                     08260004
         STCM  R15,B'0100',1(R14)      00YYDDDF---C                     08270004
         L     R0,0(R14)               FFYYDDDF                         08280004
.*       MVI   0(R14),0                +++++ CONFIRM TOP BYTE 0         08290034
         NI    0(R14),X'01'            KEEP 2000 FLAG                   08300034
         L     R1,0(R14)                                                08310004
         UNPK  0(6,R14),1(3,R14)       F0FYFYFDFDFD                     08320004
         LTR   R0,R0                   +++++ TEST SIGN OF R0            08330004
         BP    UDT&IX.P                +++++                            08340004
         LA    R14,4                   +++++ FLAG=4                     08350004
         B     UDT&IX.R                +++++                            08360004
UDT&IX.P EQU   *                       +++++                            08370004
         LA    R14,0                   +++++ FLAG=0                     08380004
UDT&IX.R EQU   *                       +++++                            08390004
         SR    R15,R15                 R.C                              08400004
         B     UDT&IX.Z                EXIT                             08410004
.*       AGO   .YMD3                                                    08420004
         AGO   .YMD3                   A#@@@3                           08430034
.INPU    ANOP                                                           08440004
         LR    R1,R0                   SAVE TOP ADDR(HEINEN)            08450004
UDT&IX.3 EQU   *                       LOP FOR  CHECK MONTH END         08460004
         CP    2(2,R14),0(2,R1)        CHECK MONTH END    ----          08470004
         BNH   UDT&IX.9                IN MONTH END                     08480004
         LA    R1,2(R1)                NEXT TABLE ENTRY                 08490004
         B     UDT&IX.3                AROUND CONSTANT                  08500004
.YMD3    ANOP                                                           08510004
         AIF   ('&TBL' NE 'N').TBLY                                     08520004
         AIF   (&UDATEGB).NOTFST2                                       08530004
&UDATEGB SETB 1                                                         08540004
.TBLY    ANOP                                                           08550004
&TB.40   DC    PL2'40'                 FOR URUDOSI KEISAN 4 YEAR        08560004
&TB.0    DC    PL2'00'                 MONTH 1 START                    08570004
&TB.H    EQU   *                       MONTH END DATE TABLE 1           08580004
         DC    PL2'31'                 MONTH 1 END                      08590004
         DC    PL2'59'                 MONTH 2 END                      08600004
         DC    PL2'90'                 MONTH 3 END                      08610004
         DC    PL2'120'                MONTH 4 END                      08620004
         DC    PL2'151'                MONTH 5 END                      08630004
         DC    PL2'181'                MONTH 6 END                      08640004
         DC    PL2'212'                MONTH 7 END                      08650004
         DC    PL2'243'                MONTH 8 END                      08660004
         DC    PL2'273'                MONTH 9 END                      08670004
         DC    PL2'304'                MONTH 10 END                     08680004
         DC    PL2'334'                MONTH 11 END                     08690004
&TB.HE   DC    PL2'365'                MONTH 12 END                     08700004
.******** URUUDOSHI DAY TABLE                                           08710004
         DC    PL2'00'                 MONTH 1 START                    08720004
&TB.U    EQU   *                       URUDOSHI DATE TABLE              08730004
         DC    PL2'31'                 MONTH 1 END                      08740004
         DC    PL2'60'                 MONTH 2 END                      08750004
         DC    PL2'91'                 MONTH 3 END                      08760004
         DC    PL2'121'                MONTH 4 END                      08770004
         DC    PL2'152'                MONTH 5 END                      08780004
         DC    PL2'182'                MONTH 6 END                      08790004
         DC    PL2'213'                MONTH 7 END                      08800004
         DC    PL2'244'                MONTH 8 END                      08810004
         DC    PL2'274'                MONTH 9 END                      08820004
         DC    PL2'305'                MONTH 10 END                     08830004
         DC    PL2'335'                MONTH 11 END                     08840004
&TB.UE   DC    PL2'366'                MONTH 12 END                     08850004
.NOTFST2 ANOP                                                           08860004
UDT&IX.9 EQU   *                       FOUND END OF MONTH               08870004
         AIF   ('&INPUT' NE 'J').YMD4  YMD TO YYDDD                     08880004
         ST    R1,0(R14)               SAVE ENTRY ADDR                  08890004
         SR    R1,R0                   ENTRY OFFSET                     08900004
         SRL   R1,1                    DEVIDE BY ENTRY LEN(2)           08910004
         LA    R1,1(R1)                MM IN BINALY                     08920004
         LA    R0,10                   FOR CHECK MONTH 10 OVER          08930004
         CR    R1,R0                   CHECK MONTH                      08940004
         BL    UDT&IX.A                LOW UNDER MONTH 9                08950004
         SR    R1,R0                   N MONTH OVER 10                  08960004
         LA    R0,X'10'                M0 IN PACK                       08970004
         OR    R1,R0                   MM IN PACK                       08980004
UDT&IX.A EQU   *                       AFTER CHECK OVER 10 MONTH        08990004
         STC   R1,5(R14)               SAVE MM IN PACK   AAAAAAAA00MM   09000004
         L     R1,0(R14)               BACK ENTRY ADDR   --------       09010004
         LA    R0,2                    1 ENTRY LEN                      09020004
         SR    R1,R0                    BACK 1 ENTRY                    09030004
         ST    R15,0(R14)              FFYYDDDC00MM +++++ STORE TO R15  09040004
         MVI   0(R14),0                +++++ CONFIRM TOP BYTE 0         09050034
         SP    0(4,R14),0(2,R1)        00YY0DDC00MM                     09060004
         MVC   4(1,R14),1(R14)         00YY0DDCYYMM                     09070004
         MVO   0(3,R14),4(2,R14)       0YYMMDDCYYMM                     09080004
         OI    3(R14),X'0F'            SIGN 4 BIT                       09090004
         L     R0,0(R14)               0YYMMDDC    PACK FMT             09100004
         SRL   R0,4                    00YYMMDD    PACK FMT             09110004
         UNPK  0(6,R14),0(4,R14)       ZONE YYMMDD                      09120004
         L    R1,16                   GET ADDR OF CVT                   09130004
         L    R1,X'38'(R1)  000YYDDDF CURRENT DATE IN PACKED DECIMAL    09140004
         LTR   R15,R15                 +++++ TEST                       09150004
         BP    UDT&IX.P                +++++                            09160004
         LA    R14,4                   +++++ FLAG=4                     09170004
         B     UDT&IX.R                +++++                            09180004
UDT&IX.P EQU   *                       +++++                            09190004
         LA    R14,0                   +++++ FLAG=0                     09200004
UDT&IX.R EQU   *                       +++++                            09210004
         SR   R15,R15                  R.C 0                            09220004
         AIF   ('&TODAY' EQ 'Y').INPZ   NOT TODAY                       09230004
         B    UDT&IX.Z                                                  09240004
.YMD4    ANOP                                                           09250004
UDT&IX.E EQU   *                       R.C SET                          09260004
         LA   R15,4                    R.C 0                            09270004
UDT&IX.Z EQU   *                       R.C SET                          09280004
.INPZ    ANOP                                                           09290004
.*                                                                      09300004
.*                                     ***** END MACRO UDATE    ******* 09310004
         MEND  UDATE                                                    09320004
.*====================================================================* 09330053
.*061123 CSECTNAME/ASMDATE FROM REMOTE PARMLIST                       * 09340053
.*====================================================================* 09350053
.* MACRO NAME : ULSNAP                                                  09360053
.* FORMAT     : &LBL USNAP  &TEXT,&SNAPAREA,&SNAPAREA,,..,&SEQNO=0,     09370053
.*                          &REG=YES,&DDNAME=,&REQ=,&BASEREG=0,         09380053
.*              &LBL       : STMT LABEL AND                             09390053
.*                           IT IS USED TO POINT TEXT AREA              09400053
.*                           TEXT AREA FIELD IS &LBL._TEXT              09410053
.*              &TEXT      : TEXT COMMENT                               09420053
.*              &SNAPAREA  : SNAP FIELD ADDR,SNAP LEN                   09430053
.*                            AREANAME   LENGTH IS L'AREANAME           09440053
.*                            (ADDR,LEN)                                09450053
.*                               ADDR : AREANAME OR (RX) FORMAT         09460053
.*                               LEN  : EQU-VALUE OR (RX) FORMAT        09470053
.*              &SEQNO     : IDENTIFICATION NUMBER                      09480053
.*                         : 0-->65537                                  09490053
.*              &REG       : YES/NO ,REG TRACE OPTION                   09500053
.*                           DEFAULT IS YES                             09510053
.*              &DDNAME    : TO CHANGE OUTPUT DDNAME                    09520053
.*                         : DEFAULT IS ULFSNPDD                        09530053
.*              &BASEREG   : USER BASEREG TO GET CSECT NAME FROM HDR    09540053
.*                         : DEFAULT IS 0,MEANS REG DECLARED AT INIT    09550053
.*                         : IF NO INIT DECLARATION,DEFAULT IS R12      09560053
.* FUNCTION   : SNAP REG AND FIELD CONTENT                              09570053
.* I/O CONDITION :                                                      09580053
.*  ALL REG PRESERVED                                                   09590053
.*  EXIT CONDITION                                                    * 09600053
.*  !!!!! MACRO IS NULIFIED BY SYSPARM=NOSNAP ASSEMBLY OPTION           09610053
.* EXAMPLE  : LBL001 ULSNAP 'AFTER CALL ABC',REG=NO,SEQNO=100           09620053
.*                   ULSNAP AREA1,((R14),(R0)),(AREA2,EQSZ)             09630053
.*                   ULSNAP ((R0),EQDSCTSZ),AH1,AH2,DDNAME=WKDDN        09640053
.*====================================================================* 09650053
         MACRO                                                          09660053
&X       ULSNAP &TEXT,&SEQNO=1,&REG=YES,&DDNAME=,&BASEREG=0             09670053
                                                                        09680053
         LCLA  &I                       INDEX  SYSLIST                  09690053
         LCLA  &PERLIST                 SAVE SYSLIST START/ADDR/PARA    09700053
         LCLC  &STRING                  CONSTRUCT STRING WITH L         09710053
         LCLC  &YSCTNA                 NAME CONTROLCSECT                09720053
         LCLA &OPT,&OPT2,&NN                                    R#@@@@2 09730053
         LCLC &WKOPTC,&TLABEL                                   R#@@@@2 09740053
         GBLC &CSECTTB(100)      ONCE GENERATE CSECTNAME AND ASMDATE    09750053
         GBLA &CSECTNO           INDEX                                  09760053
         LCLB &CSECTSW                                                  09770053
         LCLC &CSECTNM                                                  09780053
         LCLA &II                                                       09790053
*                                 START MACRO ULSNAP ****************** 09800053
.*                                 PROCESS LABEL                        09810053
&X       DS    0H                       ON HALFW BOUNDARY/JUST IN CASE  09820053
.*                                 DO COMMENT FOR BETTER REFERENCE      09830053
&I       SETA  1                        TO TEST FOR TEXT                09840053
.*                                 TEST TO AVOID DIAGNOSTICS/NO POS OP  09850053
         AIF   ('&SYSLIST(&I)' EQ '').NOPOS   BRANCH NO POSITIONAL OPER 09860053
         AIF   ('&SYSLIST(&I)'(1,1) EQ '''').F1                         09870053
         AGO   .TOG1                                                    09880053
.*                                 NO POSITIONAL OPERAND SPECIFIED      09890053
.NOPOS   ANOP                                                           09900053
         MNOTE *,'ULSNAP MACRO:NO TEXT SPECIFIED/NO ADDRESS SPECIFIED'  09910053
         AGO   .TOG1                                                    09920053
.*                                 TEXT IS PRESENT                      09930053
.F1      ANOP                                                           09940053
&I       SETA  2                        SET INDEX POSITIONAL PARA/START 09950053
.TOG1    ANOP                                                           09960053
.OK1     ANOP                                                           09970053
         AIF   ('&REG' EQ 'NO' OR '&REG' EQ 'YES').OK2                  09980053
         MNOTE 8,'ULSNAP MACRO:REG OPERAND IS NOT YES/NO'               09990053
*                                 END MACRO ULSNAP  ******************* 10000053
.OK2     ANOP                                                           10010053
         AIF   ('&SYSPARM' NE 'NOSNAP').IGNORNO NOP MACRO TEST          10020053
.*                                      MACRO IS IGNORED                10030053
*                                       ULSNAP MACRO IGNORED/SYSPARM    10040053
*                                       NOSNAP HAS BEEN USED            10050053
*                                 END MACRO ULSNAP  ******************* 10060053
         MEXIT                                                          10070053
.*********************************************************************  10080053
.IGNORNO  ANOP                          MACRO NOT IGNORED               10090053
         LCLC  &LNKCSCT                                                 10100053
&LNKCSCT SETC  'XE4S002Z'         * LINKAGE PGM CSECT NAME              10110053
.*                                                                      10120053
&PERLIST SETA  &I                       SAVE POSIOTION/ADDRESS PARA     10130053
.*                                 BUILD NAME OF PRINTCONTROLCSECT      10140053
.*                                                                      10150053
.* SEARCH CSECT TBL                                                     10160053
&II      SETA  0                                                        10170053
.LOOP    ANOP                                                           10180053
&II      SETA  &II+1                                                    10190053
         AIF (&II GT &CSECTNO).NOTF                                     10200053
         AIF ('&SYSECT' EQ '&CSECTTB(&II)').FOUND                       10210053
         AGO  .LOOP                                                     10220053
.FOUND   ANOP                                                           10230053
&CSECTSW SETB  0                                                        10240053
         AGO   .COM1                                                    10250053
.NOTF    ANOP                                                           10260053
&CSECTSW SETB  1                                                        10270053
&CSECTNO SETA  &CSECTNO+1                                               10280053
&CSECTTB(&CSECTNO) SETC '&SYSECT'                                       10290053
.COM1    ANOP                                                           10300053
&CSECTNM SETC '&SYSECT'                                                 10310053
.*                                                                      10320053
.*                                                                      10330053
&YSCTNA SETC  '@'.'&SYSECT'(1,7)   UNIQUE NAME PRINTCONTROLCSECT        10340053
         STM   R14,R12,12(R13)     BY SA=CURRENT SPECIFICATION          10350053
         L R15,=V(&LNKCSCT)        INTERFACE MODULE                     10360053
         CNOP  2,4                                                      10370053
         BALR  R14,R15             REMOTE PARM FROM R14+4               10380053
         B     *+8                                                      10390053
         DC    A(#@#U&SYSNDX)      REMOTE PARM                          10400053
         LM    R14,R12,12(R13)     RESTORE REG                          10410053
.*********************************************************************  10420053
&YSCTNA CSECT                          CONTROLSECT PRINT                10430053
         AIF (NOT &CSECTSW).NONAME                                      10440053
         DC  CL8'&CSECTNM'                                              10450053
         DC  CL8'&SYSDATE'                                              10460053
         DC  CL6'&SYSTIME'                                              10470053
.NONAME  ANOP                                                           10480053
.*SETUP OPTION                                                          10490053
&NN      SETA  1                                                        10500053
&OPT     SETA 0                                                         10510053
&OPT2    SETA 0                                                         10520053
&WKOPTC  SETC 'OPT='                                                    10530053
         AIF ('&TEXT' EQ '').NOTXT3                                     10540053
         AIF ('&TEXT'(1,1) NE '''').NOTXT3                              10550053
&OPT     SETA &OPT+1                   TEXT EXIST OPTION                10560053
&WKOPTC  SETC '&WKOPTC'.'TEXT '                                         10570053
.NOTXT3  ANOP                                                           10580053
         AIF ('&REG' EQ 'NO').NOREG3                                    10590053
&OPT     SETA &OPT+2                   REG TRACE  OPTION                10600053
&WKOPTC  SETC '&WKOPTC'.'REG=YES '                                      10610053
.NOREG3  ANOP                                                           10620053
         AIF ('&DDNAME' EQ '').NODDN3                                   10630053
&NN      SETA &NN+1                   DDNAME     OPTION                 10640053
&OPT     SETA &OPT+4                   DDNAME     OPTION                10650053
&WKOPTC  SETC '&WKOPTC'.'DDNAME '                                       10660053
         AIF ('&DDNAME'(1,1) NE '''').NODDN3                            10670053
&OPT     SETA &OPT+8                   LITERAL DDNAME OPTION            10680053
&WKOPTC  SETC '&WKOPTC'.'CONST DDN '                                    10690053
.NODDN3  ANOP                                                           10700053
.*                                                                      10710053
#@#U&SYSNDX DS 0F                       REFERENCED BY ADDRESS INLINE    10720053
&WKOPTC  SETC 'AL1(&OPT) &WKOPTC'                                       10730053
         DC    A(&YSCTNA)                CSECT TOP                      10740053
         DC    AL2(&SEQNO)              SEQ NUMBER ULSNAP               10750053
         DC    &WKOPTC                                                  10760053
         DC    AL1(&OPT2+&BASEREG)                                      10770053
         AIF ('&DDNAME' EQ '').NODDN4                                   10780053
         AIF ('&DDNAME'(1,1) EQ '''').DDNCONS                           10790053
         AIF ('&DDNAME'(1,1) EQ '(').DDNREG                             10800053
         DC   SL2(&DDNAME)         DDNAME PTR                           10810053
         AGO .NODDN4                                                    10820053
.DDNREG  ANOP                                                           10830053
         DC    AL2(16*256*&DDNAME(1)) REGISTER NOTATION DDNAME          10840053
         AGO .NODDN4                                                    10850053
.DDNCONS ANOP                                                           10860053
         DC  CL8&DDNAME            DDNAME CONSTANT                      10870053
.NODDN4  ANOP                                                           10880053
.*                                 WORK ON TEXT                         10890053
&I       SETA  1                        TO TEST FOR TEXT                10900053
         AIF   ('&SYSLIST(&I)' EQ '').BLANKT BRANCH NO POSITIONAL PREST 10910053
         AIF   ('&SYSLIST(&I)'(1,1) NE '''').BLANKT BRCH NO QUOTES      10920053
.*                                 TEXT IS PRESENT                      10930053
&TLABEL  SETC 'SNP&SYSNDX.T'                                            10940053
.*                                 TEXT IS PRESENT                      10950053
         DC    AL2(L'&TLABEL)                                           10960053
&TLABEL  DC    C&TEXT                   TEXT/FIRST OPERAND/USNAP        10970053
.BLANKT  ANOP                           ENTRY POINT NO TEXT             10980053
.*                                 WORK ON ADDRESSES                    10990053
&I       SETA  &PERLIST                 RESTORE START ADDRESS           11000053
.LOOPGEN ANOP                      GENERATE LIST/LOOP/FIELD             11010053
         AIF   ('&SYSLIST(&I)' EQ '').NOTPR BRANCH FIELD NOT PRESENT    11020053
.*                                 FIELD PRESENT TEST IF LENGTH PRESENT 11030053
         AIF ('&SYSLIST(&I,2)' EQ '').NOLEN BRANCH NO LEN PARA          11040053
.*                                 LENGTH IS STATED IN OPERAND          11050053
.*                                 TEST IF LENGTH IN REG NOTATION       11060053
         AIF   ('&SYSLIST(&I,2)'(1,1) EQ '(').REGNOT1                   11070053
.*                                 LENGTH NOT IN REGISTER NOTATION      11080053
         DC    AL2(&SYSLIST(&I,2))      LENGTH/FIELD/AS PER OPERAND     11090053
         AGO   .TOLEN                                                   11100053
.*                                 LENGTH IS IN REGISTER NOTATION       11110053
.REGNOT1 ANOP                                                           11120053
         DC    XL1'80'                  LENGTH IS IN REG NOTATION       11130053
         DC    AL1(&SYSLIST(&I,2))      LENGTH/REGISTER NOTATION        11140053
         AGO   .TOLEN                                                   11150053
.*                                 LENGTH IS NOT SPECIFIED/USE IMPLIED  11160053
.NOLEN   ANOP                                                           11170053
.*                                 WORK ON IMPLIED LENGTH               11180053
.*                                 TEST IF FIELD IN REG NOTATION        11190053
.*                                 REG HAS NO IMPLIED LENGTH            11200053
         AIF   ('&SYSLIST(&I,1)'(1,1) EQ '(').REGNOT3                   11210053
.*       AIF   ('&SYSLIST(&I)'(1,1) EQ '(').REGNOT3 ALSO PERMITTED      11220053
.*       MNOTE '&SYSLIST(&I)'                                           11230053
.*                                 NO LENGTH SPECIFIED/FIELD NOT PRESEN 11240053
.*                                 CONSTRUCT PROPER STRING              11250053
&STRING  SETC  'L''&SYSLIST(&I,1)'      CONSTRUCT L/STRING              11260053
         DC    AL2(&STRING)             LENGTH/FIELD/IMPLIED            11270053
.*                                 LENGTH SPECIFIED/FIELD REG OR NOT    11280053
.TOLEN   ANOP                                                           11290053
.*                                      TEST FOR REGISTER NOTATION/FIEL 11300053
.*                                 IF LENGTH IS SPECIFIED DOUBLE PAR    11310053
.*                                 ARE REQ FOR REG NOTATION FIELD       11320053
         AIF   ('&SYSLIST(&I,1)'(1,1) EQ '(').REGNOT2 IF LENGTH/DOUBLE  11330053
.*                                 FIELD NOT REGISTER NOTATION          11340053
         DC    SL2(&SYSLIST(&I,1))      ADDRESS/FIELD                   11350053
         DC    CL8'&SYSLIST(&I,1)'      NAME/FIELD                      11360053
&I       SETA  &I+1                     NEXT FIELD TO BE TESTED/INDEX   11370053
         AGO   .LOOPGEN                 PROCESS IN LOOP                 11380053
.*                                 ADDRESS IN REGNOTATION/NO LENGTH SPE 11390053
.REGNOT3 ANOP                                                           11400053
         DC    AL2(100)                 LENGTH/DEFAULT/FIELD IN REGNOTA 11410053
.*                                 ADDRESS IS IN REG NOTATION           11420053
.*                                 ENTRY POINT LEN SPEC/FIELD REG NOTA  11430053
.REGNOT2 ANOP                                                           11440053
         DC    AL2(16*256*&SYSLIST(&I,1)) REGISTER NOTATION/FIELD       11450053
         DC    CL8'&SYSLIST(&I,1)'      NAME/FIELD                      11460053
&I       SETA  &I+1                     NEXT FIELD                      11470053
         AGO   .LOOPGEN                                                 11480053
.*                                 ALL FIELDS/PARAMRTR PROCESSED        11490053
.NOTPR   ANOP                                                           11500053
         DC    X'FF'                    END PARAMETER LIST/ULSNAP MACRO 11510053
&SYSECT  CSECT                          RESUME PROGRAM CSECT            11520053
**********                       END MACRO ULSNAP  ******************** 11530053
         MEND  ULSNAP                                                   11540053
.********************************************************************** 11550053
         MACRO                                                          11560053
&NAME    UERREXIT &MSG                                                  11570034
         LA R0,&MSG                                                     11580034
         BAL R14,ERRMSG                                                 11590034
         MEND  UERREXIT                                                 11600034
.********************************************************************** 11610034
*********************************************************************** 11620004
         GBLSET                 FOR INLINE MACRO                        11630004
         REGISTER               REG EQU                                 11640004
*********************************************************************** 11650001
XE4S001Z CSECT                                                          11660001
         SAVE (14,12)                                                   11670001
         USING XE4S001Z,R12,R11,R10,R9                                  11680032
         LR R12,R15                                                     11690001
         LA R9,4095                                                     11700032
         LA R9,1(R9)                                                    11710032
         LR R11,R12                                                     11720032
         AR R11,R9                                                      11730032
         LR R10,R11                                                     11740032
         AR R10,R9                                                      11750032
         AR R9,R10                                                      11760032
         ST R15,8(R13)                                                  11770001
         ST R13,4(R15)                                                  11780001
         LR R13,R15                                                     11790001
*                                                                       11800001
         USING PDS2,R3                                                  11810001
         USING S99RB,R4                ESTABLISH ADDRSBLTY FOR RB       11820007
*                                                                       11830001
         LR R5,R1                      PARMREG                          11840006
*                                                                       11850006
         MVC DCBDDNAM-IHADCB+OUTDCB,BLANK                               11860012
         BAL R14,GETTJID               GET TSO JOBID TO CHK UNDER TSO   11870000
         BAL R14,SOALLOC                                                11880012
         MVC DCBDDNAM-IHADCB+OUTDCB,RETDDN                              11890012
         OPEN (OUTDCB,(OUTPUT))        SYSOUT                           11900006
         IF (TM,DCBOFLGS-IHADCB+OUTDCB,DCBOFOPN,NO)                     11910006
           MVC ERRMSG04(8),DCBDDNAM-IHADCB+OUTDCB                       11920006
           UERREXIT ERRMSG04                                            11930034
         ENDIF                                                          11940006
*                                                                       11950006
         BAL R14,PXMSESTS        ESTAE SET                              11960006
         BAL R14,GETPARM         CHECK EXEC PARM                        11970030
         MVC DCBDDNAM-IHADCB+PDSDCB,BLANK      NOT ALLOC ID             11980039
         MVC DCBDDNAM-IHADCB+PDSDCB2,BLANK     NOT ALLOC ID             11990039
         MVC DCBDDNAM-IHADCB+PDSDCB3,BLANK     NOT ALLOC ID             12000039
         BAL R14,DSALLOC                                                12010006
         MVC DCBDDNAM-IHADCB+PDSDCB,RETDDN                              12020006
         MVC DCBDDNAM-IHADCB+PDSDCB2,RETDDN                             12030006
         MVC DCBDDNAM-IHADCB+PDSDCB3,RETDDN                             12040030
*CONFIRM PDS                                                            12050006
         BAL R14,DSINFO                                                 12060023
         IF (CLI,WFUNCID,E,EQFSPFUP)  FUNCTION ID=UPDDATE         A#002 12070030
           BAL R14,SPFUPDAT                                       A#002 12080030
           B EXIT                                                 A#002 12090030
         ENDIF                                                    A#002 12100030
*DIRECTORY PROCESS                                                      12110006
         OPEN (PDSDCB2,(INPUT))                                         12120001
         IF (TM,DCBOFLGS-IHADCB+PDSDCB2,DCBOFOPN,NO)                    12130004
           MVC ERRMSG02+3(8),DCBDDNAM-IHADCB+PDSDCB2                    12140004
           LA R0,ERRMSG02                                               12150004
           BAL R14,ERRMSG                                               12160004
         ENDIF                                                          12170001
         BAL R14,DISPHDR                                                12180027
       IF (CLI,PARMMEMB,NE,C' ')    MEMBERNAME SPECIFIED      A#001     12190030
         LA R2,PDSDCB2                DCB ADDR:PARM TO BLDLMEMB         12200030
         BAL R14,BLDLMEMB                                     A#001     12210030
         LA R3,BLDLPENT               PDS2 BASE                         12220030
         BAL R14,DISPMEMB                                     A#001     12230030
       ELSE                                                             12240030
         DO INF                                                         12250001
           XC DECB(4),DECB         * DECB CLEAR                         12260001
           READ DECB,SF,PDSDCB2,DIRAREA,'S'                             12270001
           CHECK DECB                                                   12280001
           LH R5,DIRAREA       *LL                                      12290001
           LA R3,DIRAREA+2                                              12300001
           SH R5,=H'2'                                                  12310006
           DO WHILE=(LTR,R5,R5,P)                                       12320001
             IF (CLC,PDS2NAME,EQ,=8XL1'FF')    * END MEMBER             12330047
               B EOFDIR                                                 12340046
             ENDIF                                                      12350046
             BAL R14,DISPMEMB                                           12360004
             IC R4,PDS2INDC                                             12370004
             N R4,=A(PDS2LUSR)     USER AREA LENGTH MASK                12380004
             SLL R4,1            LEN IS HALFWORD COUNT                  12390004
             LA R4,PDS2USRD-PDS2(R4)                                    12400004
             AR R3,R4                                                   12410001
             SR R5,R4                                                   12420001
           ENDDO                                                        12430001
         ENDDO                                                          12440001
EOFDIR   EQU *                                                          12450001
       ENDIF                                                            12460030
         BAL R14,PUTENDL                                                12470043
         LA R15,0                                                       12480001
EXIT     EQU *                                                          12490001
         BAL R14,CLOSEFRE                                               12500000
         L R13,4(R13)                                                   12510001
         RETURN (14,12),RC=(15)                                         12520004
**********************************************************************  12530043
* PRINT END OF LIST                                         A#002       12540043
**********************************************************************  12550043
PUTENDL  DS 0H                                                          12560043
         ST R14,SVR14EL                                                 12570043
*                                                                       12580043
         L R2,LINENO                                                    12590043
         UI2Z (R2),HDR3+14,LEN=6                                        12600043
         L R2,ALIASNO                                                   12610043
         UI2Z (R2),HDR3+29,LEN=6                                        12620043
         LA R0,HDR3                                                     12630043
         BAL R14,ERRMSG                                                 12640043
*                                                                       12650043
         L  R14,SVR14UP                                                 12660043
         BR R14                                                         12670043
****************                                                        12680043
SVR14EL  DS F                                                           12690043
HDR3     DC    CL80'-END OF LIST- XXXXXX MEMBER (XXXXXX ALIAS)'         12700043
**********************************************************************  12710030
* SPF INFO UPDATE                                           A#002       12720030
**********************************************************************  12730030
SPFUPDAT DS 0H                                                          12740030
         ST R14,SVR14UP                                                 12750030
*                                                                       12760030
         IF (TM,SPFSW,EQUSPFF,NO)     RECFM=F,LRECL=80                  12770030
           UERREXIT ERRMSG09                                            12780034
         ENDIF                                                          12790030
*                                                                       12800030
         LA R2,PDSDCB3                                                  12810030
         OPEN ((R2),(UPDAT))                                            12820030
         IF (TM,DCBOFLGS-IHADCB(R2),DCBOFOPN,NO)                        12830030
           MVC ERRMSG02+3(8),DCBDDNAM-IHADCB(R2)                        12840030
           UERREXIT ERRMSG02                                            12850034
         ENDIF                                                          12860030
         IF (CLI,PARMMEMB,E,C' ') //NO MEMBER PARM                      12870048
           UERREXIT ERRMSGMM                                            12880048
         ENDIF                                                          12890048
         LA R1,8                                                        12900000
         UMEMCHR PARMMEMB,C'*',(R1)                               A#003 12910044
 ULSNAP 'WILDC   '                                                      12920000
         IF (LTR,R1,R1,Z)                                         A#003 12930044
           LA R1,8                                                      12940000
           UMEMCHR PARMMEMB,C'?',(R1)                             A#003 12950044
         ENDIF                                                    A#003 12960044
 ULSNAP 'WILDC   '                                                      12970000
         IF (LTR,R1,R1,NZ)  WILDCARD                              A#003 12980045
           BAL R14,SPFUPDT2                                       A#003 12990045
         ELSE                                                           13000046
           BAL R14,DISPHDR                                              13010040
           BAL R14,SPFUPDTM                                             13020044
         ENDIF                                                    A#003 13030000
*                                                                       13040044
         BAL R14,PUTENDL                                                13050000
         L  R14,SVR14UP                                                 13060031
         BR R14                                                         13070031
****************                                                        13080031
SVR14UP  DS F                                                           13090031
ERRMSGMM DC CL80' * MEMBER NAME REQUIRED(USE * TO APPLY TO WHOLE D/S'   13100050
**********************************************************************  13110044
* SPF INFO UPDATE FOR MEMBERS                               A#003       13120044
**********************************************************************  13130044
SPFUPDT2 DS 0H                                                          13140044
         ST R14,SVR14UP2                                                13150044
*                                                                       13160044
         MVC WILDMEMB,PARMMEMB                                          13170046
         LA R0,EOFDIR2                                                  13180046
         STCM R0,B'0111',DCBEODA-IHADCB+PDSDCB2                         13190046
         OPEN (PDSDCB2,(INPUT))                                         13200046
         IF (TM,DCBOFLGS-IHADCB+PDSDCB2,DCBOFOPN,NO)                    13210046
           MVC ERRMSG02+3(8),DCBDDNAM-IHADCB+PDSDCB2                    13220046
           LA R0,ERRMSG02                                               13230046
           BAL R14,ERRMSG                                               13240046
         ENDIF                                                          13250046
*GET MEMBERNAME(DUP MEMBER READ IF REPEAT REAN/UPDATE)                  13260000
         DO INF                                                         13270044
           XC DECB2(4),DECB2         * DECB CLEAR                       13280044
           READ DECB2,SF,PDSDCB2,DIRAREA,'S'                            13290046
           CHECK DECB2                                                  13300044
 ULSNAP 'DIR READ',(DIRAREA,256)                                        13310046
           LH R5,DIRAREA       *LL                                      13320044
           LA R3,DIRAREA+2                                              13330044
           SH R5,=H'2'                                                  13340044
           DO WHILE=(LTR,R5,R5,P)                                       13350044
             IF (CLC,PDS2NAME,EQ,=8XL1'FF')    * END MEMBER             13360044
               B EOFDIR2                                                13370046
             ENDIF                                                      13380046
             IF (CLI,WILDMEMB,NE,C' ')                                  13390045
               LA R1,PDS2NAME                                           13400000
               LA R2,WILDMEMB            WILDCARD                       13410000
               BAL R14,WILDCHK                                          13420045
             ELSE                                                       13430045
               SR R15,R15                                               13440045
             ENDIF                                                      13450045
             IF (LTR,R15,R15,Z)     //WILDCARD MATCH                    13460045
               LA R0,12             PTR AND MEMBNAME                    13470046
               GETMAIN RC,LV=(R0)                                       13480000
               IF (LTR,R15,R15,NZ)                                      13490000
                 UERREXIT ERRMSG21                                      13500000
               ENDIF                                                    13510000
               LR R2,R1                                                 13520046
               L R1,MEMBLIST                                            13530046
               IF (LTR,R1,R1,Z)     1ST MEMBER                          13540046
                 ST R2,MEMBLIST                                         13550046
                 ST R2,MEMBLSTE                                         13560046
               ELSE                                                     13570046
                 L R1,MEMBLSTE      LAST ENTRY                          13580046
                 ST R2,0(R1)        CHAIN TO LAST                       13590046
                 ST R2,MEMBLSTE                                         13600046
               ENDIF                                                    13610046
               XC 0(4,R2),0(R2)     NEXT CHAIN                          13620046
               MVC 4(8,R2),PDS2NAME                                     13630046
             ENDIF                                                      13640045
             IC R4,PDS2INDC                                             13650044
             N R4,=A(PDS2LUSR)     USER AREA LENGTH MASK                13660044
             SLL R4,1            LEN IS HALFWORD COUNT                  13670044
             LA R4,PDS2USRD-PDS2(R4)                                    13680044
             AR R3,R4                                                   13690044
             SR R5,R4                                                   13700044
           ENDDO                                                        13710044
         ENDDO                                                          13720044
EOFDIR2  EQU *                                                          13730044
*                                                                       13740044
         CLOSE (PDSDCB2)                                                13750046
         BAL R14,DISPHDR                                                13760000
         L R3,MEMBLIST                                                  13770046
         IF (LTR,R3,R3,Z)                                               13780046
            UERREXIT ERRMSG22                                           13790049
         ENDIF                                                          13800046
         DO WHILE=(LTR,R3,R3,NZ)                                        13810000
           SR R0,R0                                                     13820000
           BCTR R0,0                                                    13830000
           ST R0,WLINENO                 RESET FOR EACH MEMBER          13840000
           ST R0,WMAXMM                                                 13850000
           MVC PARMMEMB,4(R3)                                           13860046
           BAL R14,SPFUPDTM                                             13870000
           LR R2,R3                                                     13880049
           L R3,0(R3)      NEXT MEMBER                                  13890046
           LA R0,12                                                     13900049
           FREEMAIN  RU,A=(R2),LV=(R0)                                  13910049
         ENDDO                                                          13920000
*                                                                       13930000
         L  R14,SVR14UP2                                                13940044
         BR R14                                                         13950044
****************                                                        13960044
SVR14UP2 DS F                                                           13970044
WILDMEMB DS CL8                                                         13980046
MEMBLIST DC F'0'    TOP ENTRY                                           13990046
MEMBLSTE DC F'0'    LAST ENTRY                                          14000046
ERRMSG21 DC CL80' * GETMAIN FOR PDS MEMBER FAILED'                      14010000
ERRMSG22 DC CL80' * NO MEMBER MATCH TO THE WILDCARD EXIST'              14020000
ERRMSG23 DC CL80' * NO MEMBER EXIST IN THE DATASET'                     14030000
**********************************************************************  14040044
* SPF INFO UPDATE FOR MEMBER OF MEMBERS                     A#003       14050044
**********************************************************************  14060044
SPFUPDTM DS 0H                                                          14070044
         STM R0,R15,SVRUPM                                              14080044
*                                                                       14090044
         LA R2,PDSDCB3                                                  14100046
         LA R3,BLDLPENT               PDS2 BASE                         14110000
         BAL R14,BLDLMEMB             R2:PARM DCB ADDR        A#001     14120046
         BAL R14,DISPMEMB                                     A#001     14130044
         ULSNAP 'BEFORE UPDATE',(PDS2NAME,DIRESZ)                       14140044
         IF (TM,SPFSW,EQUOTHER,NO)     NOT SPF AND NOT NULL INFO        14150044
           IF (TM,SPFSW,EQUSPFI,NO)    NO SPF INFO                      14160044
              XC PDS2USRD(SPFISZ),PDS2USRD                              14170044
              MVI PDS2INDC,PDS2SPFI SPF INFO DATALEN=0F(30 BYTE)        14180044
           ENDIF                                                        14190044
           BAL R14,GETSPFPM                                             14200000
           ULSNAP 'STOW DATA',(PDS2NAME,DIRESZ)                         14210044
           STOW  PDSDCB3,PDS2NAME,R      REPLACE OPTION                 14220044
           ULSNAP 'STOW REPLACE AFTER',(PDS2NAME,DIRESZ)                14230044
           IF (LTR,R15,R15,NZ)                                A#005     14221064
             MVC ERRMSGSE+19(8),PDS2NAME                      A#005     14222064
             UI2X     (R15),ERRMSGSE+19+8+4                   A#005     14222165
             UERREXIT ERRMSGSE                                A#005     14223064
           ENDIF                                              A#005     14224064
         ENDIF                                                          14240000
         LA R3,BLDLPENT               PDS2 BASE                         14250044
         MVI DISPUPDT,1               PARM TO DISPMEMB                  14260046
         BAL R14,DISPMEMB                                     A#001     14270044
         MVI DISPUPDT,0                                                 14280046
*                                                                       14290044
SPFUPDME DS 0H                                                          14300044
         LM  R0,R15,SVRUPM                                              14310044
         BR R14                                                         14320044
****************                                                        14330044
SVRUPM   DS 16F                                                         14340044
ERRMSGSE DC CL80' * STOW FAILED FOR XXXXXXXX RC=XXXXXXXX *' A#005       14341065
**********************************************************************  14350000
* WILDCARD COMPARE R1:MEMBERNAME TO BE CHKED,R2:WILDCARD                14360045
**********************************************************************  14370000
WILDCHK  DS 0H                                                          14380045
         STM R14,R3,SVRWC                                               14390045
*                                                                       14400045
 ULSNAP 'WILDCHK',((R1),8),((R2),8)                                     14410046
         L R3,WILDLEN                                                   14420047
         IF (LTR,R3,R3,Z)                                               14430047
           LR R15,R2                                                    14440047
           DO FROM=(R0,8)                                               14450047
           DOEXIT (CLI,0(R15),E,C' ')                                   14460047
             LA R3,1(R3)                                                14470047
             LA R15,1(R15)                                              14480047
           ENDDO                                                        14490047
           ST R3,WILDLEN                                                14500047
         ENDIF                                                          14510047
         LR R15,R1                                                      14520047
         SR R14,R14                                                     14530047
         DO FROM=(R0,8)                                                 14540047
         DOEXIT (CLI,0(R15),E,C' ')                                     14550047
           LA R14,1(R14)                                                14560047
           LA R15,1(R15)                                                14570047
         ENDDO                                                          14580047
         LR R0,R14                 MEMBNAME LEN                         14590047
*                                                                       14600047
         SR R15,R15                RC                                   14610045
         DO WHILE=(LTR,R3,R3,P)                                         14620045
           IF (CLI,0(R2),E,C'*')                                        14630045
             DO WHILE=(LTR,R3,R3,P)                                     14640045
             DOEXIT (CLI,0(R2),NE,C'*'),AND,(CLI,0(R2),NE,C'?')         14650045
               LA R2,1(R2)                                              14660045
               BCTR R3,0                                                14670045
             ENDDO                                                      14680045
             IF (LTR,R3,R3,NP)          LAST *                          14690045
  ULSNAP 'WILDCHK6',((R2),1),((R1),1)                                   14700047
               B WILDCHKE                                               14710045
             ENDIF                                                      14720045
             DO WHILE=(LTR,R0,R0,P)                                     14730045
             DOEXIT (CLC,0(1,R2),EQ,0(R1))                              14740045
               LA R1,1(R1)                                              14750045
               BCTR R0,0                                                14760045
             ENDDO                                                      14770045
             IF (LTR,R0,R0,NP)          NEXT CHAR OF '*' NOT FOUND      14780045
  ULSNAP 'WILDCHK7',((R2),1),((R1),1)                                   14790047
               LA R15,4                                                 14800045
               B WILDCHKE                                               14810045
             ENDIF                                                      14820045
           ELSE                      MOT "*"                            14830045
             IF (LTR,R0,R0,NP)       NO TARGET BUT MORE WORD            14840045
  ULSNAP 'WILDCHK3',((R2),1),((R1),1)                                   14850047
               LA R15,4                                                 14860045
               B WILDCHKE                                               14870045
             ENDIF                                                      14880045
             IF (CLI,0(R2),NE,C'?'),AND,(CLC,0(1,R1),NE,0(R2))  UNMATCH 14890045
  ULSNAP 'WILDCHK2',((R2),1),((R1),1)                                   14900047
               LA R15,4                                                 14910045
               B WILDCHKE                                               14920045
             ENDIF                                                      14930045
           ENDIF                                                        14940045
           LA R1,1(R1)                                                  14950045
           LA R2,1(R2)                                                  14960045
           BCTR R0,0                                                    14970045
           BCTR R3,0                                                    14980045
         ENDDO                                                          14990045
         SR R15,R15                                                     15000045
WILDCHKE EQU *                                                          15010045
 ULSNAP 'WILDCHK RC=R15'                                                15020046
*                                                                       15030000
         L R14,SVRWC                                                    15040045
         LM  R0,R3,SVRWC+4*2                                            15050045
         BR R14                                                         15060000
****************                                                        15070000
SVRWC    DS 6F                                                          15080045
WILDLEN  DC F'0'                                                        15090000
**********************************************************************  15100045
* ANALYZE EXEC PARM                                                     15110031
**********************************************************************  15120031
GETPARM  DS 0H                                                          15130031
         ST R14,SVR14GP                                                 15140031
*                                                                       15150031
         L R1,0(R5)                                                     15160031
         LH R2,0(R1)                   * REG2 = PARM LENGTH             15170031
         LA R1,2(R1)                   PARM TOP                   A#002 15180031
 ULSNAP 'EXE PARM',((R1),(R2))                                   A#002  15190033
         IF (CH,R2,H,=Y(2))                                       A#002 15200031
           IF (CLC,0(2,R1),EQ,=C'1,')  FUNCTINID:UPDATE SPF INFO  A#002 15210031
             MVI WFUNCID,EQFSPFUP                                 A#002 15220031
             LA R1,2(R1)               DSN TOP                    A#002 15230031
             SH R2,=Y(2)               PARM LEN                   A#002 15240031
             LR R3,R1                                             A#002 15250031
             LR R4,R2                                             A#002 15260031
             UMEMCHR (R3),C',',(R4)                               A#002 15270031
             IF (LTR,R1,R1,NZ)                                    A#002 15280031
               LA R15,1(R1)            SPF PARM START ADDR        A#002 15290031
               LA R14,0(R3,R4)         PARM END                   A#002 15300031
               SR R14,R15              SPF PARM LEN               A#002 15310031
               LR R2,R1                DSN END ADDR               A#002 15320031
               SR R2,R3                DSN LENGTH                 A#002 15330031
             ELSE                                                 A#002 15340031
               LA R14,0                SPF PARM LEN               A#002 15350031
               LR R2,R4                DSN LENGTH                 A#002 15360031
             ENDIF                                                A#002 15370031
             LR R1,R3                  DSN ADDR                   A#002 15380031
             ST R15,WSPFPA             SPF PARM ADDR              A#002 15390033
             ST R14,WSPFPL             SPF PARM LEN               A#002 15400033
 ULSNAP 'SPFPARM',((R15),(R14))                                   A#002 15410031
           ENDIF                       FUNCTINID:UPDATE SPF INFO  A#002 15420031
         ENDIF                                                          15430031
         LR R15,R2                                                      15440031
         BCTR R15,0                                                     15450031
       IF (LTR,R15,R15,NM)                                        A#004 15451058
         EX R15,MVCHDR1                                                 15460031
       ENDIF                                                      A#004 15461058
         IF (LTR,R2,R2,Z)                                               15470031
           LA R0,ERRMSG03                                               15480031
           BAL R14,ERRMSG                                               15490031
         ELSE                                                           15500031
*          LA R1,2(R1)                                            D#002 15510031
           LR R3,R1                                                     15520031
           UMEMCHR (R3),C'(',(R2)                                       15530031
           IF (LTR,R1,R1,NZ)      FOUND                                 15540031
             LA R14,1(R1)         MEMBNAME ADDR                         15550031
             SR R1,R3             DSN LEN                               15560031
             LR R15,R2                                                  15570031
             SR R15,R1                                                  15580031
             BCTR R15,0           FOR 1ST  '(' MEMBNAME LEN             15590031
             BCTR R15,0           FOR LAST ')' MEMBNAME LEN             15600031
             IF (LTR,R15,R15,NP),OR,(CH,R15,GT,=H'8')                   15610031
               LA R0,ERRMSG06                                           15620031
               BAL R14,ERRMSG                                           15630031
             ENDIF                                                      15640031
             BCTR R15,0                                                 15650031
             LR R1,R14                                                  15660031
             EX R15,SAVEMEMB                                            15670031
             LA R15,3(R15)                                              15680031
             SR R2,R15                                                  15690031
             LR R1,R3            DSN TOP                                15700031
 ULSNAP 'MEMB   ',(PARMMEMB,8)                                          15710033
           ELSE                                                         15720031
             LR R1,R3            DSN ADDR                               15730031
           ENDIF                                                        15740031
           IF (LTR,R2,R2,NP),OR,(CH,R2,GT,=H'44')                       15750031
             LA R0,ERRMSG06                                             15760031
             BAL R14,ERRMSG                                             15770031
           ENDIF                                                        15780031
           STH R2,PARMDSNL                                              15790031
           BCTR R2,0                                                    15800031
           EX R2,SAVEDSN                                                15810031
           LA R2,1(R2)                                                  15820033
 ULSNAP 'DSN    ',(PARMDSN,(R2))                                        15830033
         ENDIF                                                          15840031
*                                                                       15850031
         L  R14,SVR14GP                                                 15860031
         BR R14                                                         15870031
****************                                                        15880031
SAVEMEMB MVC   PARMMEMB(0),0(R1)                                        15890031
SAVEDSN  MVC   PARMDSN(0),0(R1)                                         15900033
SVR14GP  DS F                                                           15910031
WSPFPA   DS F      SPF PARM ADDR              A#002                     15920031
WSPFPL   DS F      SPF PARM LEN               A#002                     15930031
PARMMEMB DC   CL8' '                                                    15940031
WFUNCID  DC X'00'  FUNCTION ID                A#002                     15950031
EQFSPFUP EQU X'01'  SPF UPDATE                 A#002                    15960031
**********************************************************************  15970031
* ANALYZE SPF INFO PARM                                A#002            15980040
**********************************************************************  15990031
GETSPFPM DS 0H                                                          16000031
         STM R0,R15,SVRGSP                                              16010033
*                                                                       16020031
         MVI CDATESW,0                 CLEAR CDATE PARM EXIST SW A#010  16021022
         L R4,WSPFPA                   SPF PARM TOP                     16030031
         L R5,WSPFPL                   SPF PARM LEN                     16040031
         LA R3,BLDLPENT                PDS2 BASE                        16050046
         SR R6,R6                      PARM NO                          16060031
*GET EACH PARM                                                          16070033
         DO WHILE=(LTR,R5,R5,P)                                         16080031
           LR R2,R4                      EACH PARM TOP                  16090031
           DO WHILE=(LTR,R5,R5,P)                                       16100031
           DOEXIT (CLI,0(R4),E,C',')                                    16110031
             BCTR R5,0                                                  16120031
             LA R4,1(R4)                                                16130031
           ENDDO                                                        16140031
           LR R1,R4                                                     16150031
           SR R1,R2                    PARM LEN                         16160031
 ULSNAP 'PARN N(R6)',((R2),(R1))                                        16170033
           IF (CH,R6,GE,=Y(EQMAXPM))          MAX 8 PARM                16180033
             UERREXIT ERRMSGS1                                          16190034
           ENDIF                                                        16200033
           LR R14,R6                                                    16210033
           SLL R14,2                   *4                               16220033
           ST R2,WSPFPAN(R14)           SAVE ADDR                       16230033
           ST R1,WSPFPLN(R14)           SAVE LEN                        16240033
           LA R6,1(R6)                 PARMNO                           16250033
           LA R4,1(R4)                                                  16260033
           BCTR R5,0                                                    16270033
         ENDDO                                                          16280031
*PROCESS EACH PARM                                                      16290033
         SR R6,R6                                                       16300033
         DO WHILE=(CH,R6,LT,=Y(EQMAXPM))                                16310033
           LR R14,R6                                                    16320033
           SLL R14,2                                                    16330033
           L R2,WSPFPAN(R14)                                            16340033
           L R1,WSPFPLN(R14)                                            16350033
 ULSNAP 'PARN SET N(R6)',((R2),(R1))                                    16360033
           LA R6,1(R6)                 PARMNO                           16370033
           SR R15,R15                  FIELD VALUE IS NEMERIC           16380034
           IF (CLI,0(R2),GE,C'0'),AND,(CLI,0(R2),LE,C'9') //NUMERIC     16390033
           ELSE                                                         16400033
             LA R15,1                  NOT NUMERIC ID                   16410034
           ENDIF                                                        16420033
*VV                                                                     16430033
           IF (CH,R6,E,=Y(1))          VV                               16440033
             IF (CH,R1,GE,=Y(3)),AND,(CLC,0(3,R2),EQ,=C'DEL')           16450035
               IF (TM,SPFSW,EQUSPFI,NO)    NO SPF INFO                  16460035
                 UERREXIT ERRMSGS2                                      16470035
               ENDIF                                                    16480035
               MVI PDS2INDC,0               CLEAR LENGTH                16490035
               B GETSPFPE                                               16500035
             ENDIF                                                      16510035
             IF (CLI,0(R2),E,C'+')                                      16520034
               SR R15,R15                                               16530034
             ENDIF                                                      16540034
             IF (LTR,R1,R1,Z),OR,(LTR,R15,R15,NZ) MISSING OPERAND       16550034
               IF (TM,SPFSW,EQUSPFI,NO)      NO SPF INFO                16560033
                 MVI SPFVV,0             IF OPERAND MISSING SET 0       16570033
               ENDIF                                                    16580033
             ELSE                                                       16590033
               IF (CLI,0(R2),E,C'+')                                    16600033
                 UATOI 1(R2),LEN=(R1)                                   16610033
                 SR R14,R14                                             16620033
                 IC R14,SPFVV                                           16630033
                 AR R1,R14                                              16640041
               ELSE                                                     16650033
                 UATOI 0(R2),LEN=(R1)                                   16660033
               ENDIF                                                    16670033
               IF (CH,R1,GT,=Y(99))                                     16680041
                 UERREXIT ERRMSGS3                                      16690041
               ENDIF                                                    16700041
               STC R1,SPFVV                                             16710041
             ENDIF                                                      16720033
           ELSE                                                         16730033
*MM                                                                     16740033
           IF (CH,R6,E,=Y(2))          MM                               16750033
             IF (CH,R1,GE,=Y(3)),AND,(CLC,0(3,R2),EQ,=C'NOW')           16760038
               MVI GETLCRQ,1           GET MAX VALUE ID                 16770038
               BAL R14,GETLINEC        ID OF CURRENT LINE COUNT         16780041
               MVI GETLCRQ,0           GET MAX VALUE ID                 16790038
               STC R1,SPFMM                                             16800038
               SR R1,R1                ID OF TODAY                      16810038
             ELSE                                                       16820038
               IF (CLI,0(R2),E,C'+')                                    16830038
                 SR R15,R15                                             16840038
               ENDIF                                                    16850038
               IF (LTR,R1,R1,Z),OR,(LTR,R15,R15,NZ) MISSING OPERAND     16860038
                 IF (TM,SPFSW,EQUSPFI,NO)      NO SPF INFO              16870038
                   MVI SPFMM,0             IF OPERAND MISSING SET 0     16880038
                 ENDIF                                                  16890038
               ELSE                                                     16900038
                 IF (CLI,0(R2),E,C'+')                                  16910038
                   UATOI 1(R2),LEN=(R1)                                 16920038
                   SR R14,R14                                           16930038
                   IC R14,SPFMM                                         16940038
                   AR R1,R14                                            16950041
                 ELSE                                                   16960038
                   UATOI 0(R2),LEN=(R1)                                 16970038
                 ENDIF                                                  16980038
                 IF (CH,R1,GT,=Y(99))                                   16990041
                   UERREXIT ERRMSGS3                                    17000041
                 ENDIF                                                  17010041
                 STC R1,SPFMM                                           17020041
               ENDIF                                                    17030038
             ENDIF                      , NOT NOW                       17040038
           ELSE                                                         17050033
*CREATION DATE                                                          17060033
           IF (CH,R6,E,=Y(3))          CDATE                            17070033
            IF (CH,R1,GE,=Y(6)),AND,(CLC,0(3,R2),EQ,=C'000000')         17080039
             XC SPFCRD,SPFCRD                                           17090039
            ELSE                                                        17100039
             IF (CH,R1,GE,=Y(3)),AND,(CLC,0(3,R2),EQ,=C'NOW')           17110034
               SR R1,R1                ID OF TODAY                      17120034
             ELSE                                                       17130039
               IF (LTR,R1,R1,Z),OR,(LTR,R15,R15,NZ) MISSING OPERAND     17140034
                 SR R1,R1                ID OF TODAY                    17150034
*                IF (TM,SPFSW,EQUSPFI,O)  PREVIOUS SPF INFO EXIST       17160039
                   BCTR R1,0              KEEP CURRENT VALUE            17170034
*                ENDIF                                                  17180039
               ELSE                                                     17190034
                 LR R1,R2                 DATE FLD ADDR                 17200034
               ENDIF                                                    17210034
             ENDIF                                                      17220033
             IF (LTR,R1,R1,NM)                                          17230033
               BAL R14,DATE2JD                                          17240033
               ST R1,SPFCRD                                             17250033
               MVI CDATESW,1           CDATE PARM SET   SW A#010        17251022
             ENDIF                                                      17260033
            ENDIF                                                       17270039
           ELSE                                                         17280033
*UPDATE DATE                                                            17290033
           IF (CH,R6,E,=Y(4))          UDATE                            17300033
            IF (CH,R1,GE,=Y(6)),AND,(CLC,0(3,R2),EQ,=C'000000')         17310039
             XC SPFCHD,SPFCHD                                           17320039
            ELSE                                                        17330039
             IF (CH,R1,GE,=Y(3)),AND,(CLC,0(3,R2),EQ,=C'NOW')           17340034
               SR R1,R1                ID OF TODAY                      17350034
             ELSE                                                       17360034
               IF (LTR,R1,R1,Z),OR,(LTR,R15,R15,NZ) MISSING OPERAND     17370034
                 SR R1,R1                ID OF TODAY                    17380034
*                IF (TM,SPFSW,EQUSPFI,O)  PREVIOUS SPF INFO EXIST       17390039
                   BCTR R1,0              KEEP CURRENT VALUE            17400034
*                ENDIF                                                  17410039
               ELSE                                                     17420034
                 LR R1,R2                 DATE FLD ADDR                 17430033
               ENDIF                                                    17440033
             ENDIF                                                      17450033
             IF (LTR,R1,R1,NM)                                          17460033
               BAL R14,DATE2JD                                          17470033
               ST R1,SPFCHD                                             17480033
               IF (CLI,CDATESW,EQ,0),AND,(OC,SPFCRD,SPFCRD,Z)  A#010    17481022
                 ST R1,SPFCRD        SET SAME AS CHANGE DATE   A#010    17481122
               ENDIF         NO PARM OF CDATE AND NULL         A#010    17482022
             ENDIF                                                      17490033
            ENDIF            , 000000                                   17500039
           ELSE                                                         17510033
*UPDATE TIME                                                            17520033
           IF (CH,R6,E,=Y(5))          UTIME                            17530033
             IF (CH,R1,GE,=Y(3)),AND,(CLC,0(3,R2),EQ,=C'NOW')           17540034
               SR R1,R1                ID OF TODAY                      17550034
             ELSE                                                       17560034
               IF (LTR,R1,R1,Z),OR,(LTR,R15,R15,NZ) MISSING OPERAND     17570034
                 SR R1,R1                ID OF TODAY                    17580034
*                IF (TM,SPFSW,EQUSPFI,O)  PREVIOUS SPF INFO EXIST       17590039
                   BCTR R1,0              KEEP CURRENT VALUE            17600034
*                ENDIF                                                  17610039
               ELSE                                                     17620034
                   LR R1,R2                 DATE FLD ADDR               17630034
               ENDIF                                                    17640033
             ENDIF                                                      17650033
             IF (LTR,R1,R1,NM)                                          17660033
               BAL R14,HHMM2TM                                          17670033
*              STH R1,SPFCHT              0000HHMM    D#009             17680021
               STCM R1,B'0110',SPFCHT     00HHMMSS    A#009             17681021
               STC R1,SPFCHTS             SECONDS     A#009             17682021
             ENDIF                                                      17690033
           ELSE                                                         17700033
*CURRENT LINE COUNT                                                     17710033
           IF (CH,R6,E,=Y(6))          CURLINE                          17720035
             IF (CH,R1,GE,=Y(3)),AND,(CLC,0(3,R2),EQ,=C'NOW')           17730034
               BAL R14,GETLINEC         ID OF CURRENT LINE COUNT        17740035
               STH R1,SPFCLNO                                           17750034
             ELSE                                                       17760034
               IF (LTR,R1,R1,Z),OR,(LTR,R15,R15,NZ) MISSING OPERAND     17770034
                 IF (TM,SPFSW,EQUSPFI,O)  PREVIOUS SPF INFO EXIST       17780034
                 ELSE                                                   17790034
                   XC SPFCLNO,SPFCLNO                                   17800034
                 ENDIF                                                  17810034
               ELSE                                                     17820034
                 UATOI (R2),LEN=(R1)                                    17830033
                 STH R1,SPFCLNO                                         17840033
               ENDIF                                                    17850033
             ENDIF                                                      17860033
           ELSE                                                         17870033
*INITIAL LINE COUNT                                                     17880035
           IF (CH,R6,E,=Y(7))          INITLINE                         17890035
             IF (CH,R1,GE,=Y(3)),AND,(CLC,0(3,R2),EQ,=C'NOW')           17900035
               BAL R14,GETLINEC         ID OF CURRENT LINE COUNT        17910035
               STH R1,SPFILNO                                           17920035
             ELSE                                                       17930035
               IF (LTR,R1,R1,Z),OR,(LTR,R15,R15,NZ) MISSING OPERAND     17940035
                 SR R1,R1                ID OF KEEP CURRENT             17950035
                 IF (TM,SPFSW,EQUSPFI,O)  PREVIOUS SPF INFO EXIST       17960035
                 ELSE                                                   17970035
                   XC SPFILNO,SPFILNO                                   17980035
                 ENDIF                                                  17990035
               ELSE                                                     18000035
                 UATOI (R2),LEN=(R1)                                    18010035
                 STH R1,SPFILNO                                         18020035
               ENDIF                                                    18030035
             ENDIF                                                      18040035
           ELSE                                                         18050035
*USERID                                                                 18060033
           IF (CH,R6,E,=Y(8))          USER                             18070033
             IF (LTR,R1,R1,Z)          MISSING OPERAND                  18080033
               IF (TM,SPFSW,EQUSPFI,O)  PREVIOUS SPF INFO EXIST         18090033
               ELSE                                                     18100033
                 MVC SPFUSR,BLANK                                       18110033
               ENDIF                                                    18120033
             ELSE                                                       18130033
               MVC SPFUSR,BLANK                                         18140033
               IF (CH,R1,GE,=Y(8))                                      18150033
                 LA R1,8                                                18160033
               ENDIF                                                    18170033
               BCTR R1,0                                                18180033
               EX R1,*+4+4                                              18190033
               B *+4+6                                                  18200033
               MVC SPFUSR(0),0(R2)                                      18210033
             ENDIF                                                      18220033
           ELSE                                                         18230033
           ENDIF                       8                                18240033
           ENDIF                       7                                18250033
           ENDIF                       6                                18260033
           ENDIF                       5                                18270033
           ENDIF                       4                                18280033
           ENDIF                       3                                18290033
           ENDIF                       1                                18300033
           ENDIF                       1                                18310033
         ENDDO                                                          18320033
GETSPFPE DS 0H                                                          18330035
         MVC SPFRSV3,BLANK                            A#008             18331020
 ULSNAP 'NEW SPFI',((R3),DIRESZ)                                        18340033
*                                                                       18350031
         LM  R0,R15,SVRGSP                                              18360033
         BR R14                                                         18370031
****************                                                        18380031
SVRGSP   DS 16F                                                         18390033
CDATESW  DS  X                  CREATION DATE SET SW       A#010        18391022
EQMAXPM  EQU 8                                                          18400033
WSPFPAN  DC (EQMAXPM)F'0'                                               18410033
WSPFPLN  DC (EQMAXPM)F'0'                                               18420033
ERRMSGS1 DC CL80' * TOO MANY SPF PARAMETER'                             18430033
ERRMSGS2 DC CL80' * NO SPF INFO TO BE DELETED'                          18440035
ERRMSGS3 DC CL80' * MAX VALUE IS 99 FOR VER/MOD'                        18450041
**********************************************************************  18460031
* GET TIME PARM AND CONV TO SPF FMT                        A#002        18470040
* PARM R1:HHMM   FLD ADDR OR 0 IF CURRENT TIME                          18480031
*   RETURN R1:00HHMMSS                                     A#009        18481021
**********************************************************************  18490031
HHMM2TM  DS 0H                                                          18500031
         ST R14,SVR14GTM                                                18510031
*                                                                       18520031
         IF (LTR,R1,R1,Z)  //CURRENT TIME                               18530031
           TIME              ,           R1:00YYDDDF R0:HHMMSSTH        18540033
           LR R1,R0                                                     18550033
*          SRL R1,16                     0000HHMM         D#009         18560021
           SRL R1,8                      00HHMMSS         A#009         18561021
         ELSE                                                           18570031
           LR R2,R1                                                     18580034
           UATOI (R2),LEN=2                                             18590031
           IF (LTR,R1,R1,M),OR,(CH,R1,GE,=Y(24))                        18600031
*            MVC ERRMSGTM+13(4),0(R2)                     D#011         18610025
             MVC ERRMSGTM+13(6),0(R2)                     A#011         18611025
             UERREXIT ERRMSGTM                                          18620034
           ENDIF                                                        18630034
           UATOI 2(R2),LEN=2                                            18640034
           IF (LTR,R1,R1,M),OR,(CH,R1,GE,=Y(60))                        18650034
*            MVC ERRMSGTM+13(4),0(R2)                     D#011         18610025
             MVC ERRMSGTM+13(6),0(R2)                     A#011         18611025
             UERREXIT ERRMSGTM                                          18670034
           ENDIF                                                        18680034
           UATOI 4(R2),LEN=2                          A#011             18681025
           IF (LTR,R1,R1,M),OR,(CH,R1,GE,=Y(60))      A#011             18682025
             MVC ERRMSGTM+13(6),0(R2)                 A#011             18683025
             UERREXIT ERRMSGTM                        A#011             18684025
           ENDIF                                                        18685025
           MVC WKTMZ(4),0(R2)                                           18690034
           PACK WKTMP(3),WKTMZ(5)         F1F2F3F4XY->1234YX            18700034
           LH R1,WKTMP                                                  18710034
           SLL R1,8                       00HHMM00     A#009            18711025
           MVC WKTMZ(2),4(R2)                          A#011            18712025
           PACK WKTMP(2),WKTMZ(3)         F1F2XY->12YX A#011            18713025
           IC R1,WKTMP                                 A#011            18714025
         ENDIF                                                          18720031
 ULSNAP 'HHMM2TM',((R2),4)                                              18730034
*                                                                       18740031
         L  R14,SVR14GTM                                                18750031
         BR R14                                                         18760031
****************                                                        18770031
SVR14GTM DS F                                                           18780031
WKTMP    DS CL3                                                         18790034
WKTMZ    DS CL5                                                         18800034
*ERRMSGTM DC CL80' * TIME PARM(XXXX) ERR'                        D#011  18810025
ERRMSGTM DC CL80' * TIME PARM(XXXXXX) ERR'                       A#011  18811025
**********************************************************************  18820031
* GET DATE PARM AND CONV TO JURIAN DATE                          A#002  18830040
* PARM R1:YYMMDD FLD ADDR OR 0 IF CURRENT DATE                          18840031
**********************************************************************  18850031
DATE2JD  DS 0H                                                          18860031
         ST R14,SVR14D2J                                                18870031
*                                                                       18880031
         IF (LTR,R1,R1,Z)  //TODAY                                      18890031
           TIME              ,           R1:00YYDDDF R0:HHMMSSTH        18900033
         ELSE                                                           18910031
           MVC WKDTZ(6),0(R1)                                           18920034
           PACK WKDTP(4),WKDTZ(7)         F1F2F3F4F5F6XY->123456YX      18930034
           L R14,WKDTP                                                  18940034
           SRL R14,8                      00YYMMDD                      18950034
           ST R14,WKDTP                                                 18960034
 ULSNAP 'DATE2J UDATE INPUT',WKDTP,((R1),6)                             18970034
           UDATE WKDTP,TODAY=N,INPUT=S    OUTPUT IS ZONE FMT YYMMDD     18980034
 ULSNAP 'DATE2J',WKDTP                                                  18990034
           IF (LTR,R15,R15,NZ)   ERR                                    19000031
             MVC ERRMSGDT+13(6),0(R2)                                   19010031
             UERREXIT ERRMSGDT                                          19020034
           ENDIF                                                        19030031
           PACK WKDTZ(4),WKDTP           00YYDDDC                       19040034
           OI WKDTZ+3,X'0F'              00YYDDDF                       19050034
           IF (CLI,WKDTZ+1,LT,X'80')                                    19060034
             MVI WKDTZ,X'01'              OVER 2000                     19070034
           ENDIF                                                        19080034
           L R1,WKDTZ                                                   19090034
         ENDIF                                                          19100031
 ULSNAP 'DATE2J R1 OUT'                                                 19110034
*                                                                       19120031
         L  R14,SVR14D2J                                                19130031
         BR R14                                                         19140031
****************                                                        19150031
SVR14D2J DS F                                                           19160031
WKDTP    DS CL6        UDATE PARM                                       19170034
         DS 0F                                                          19180034
WKDTZ    DS CL7                                                         19190034
ERRMSGDT DC CL80' * DATE PARM(XXXXXX) ERR'                              19200031
**********************************************************************  19210031
* COUNT LINE BY READING MEMBER                                 A#002    19220040
**********************************************************************  19230031
GETLINEC  DS 0H                                                         19240031
         STM R0,R15,SVRLC                                               19250031
*                                                                       19260000
         L R1,WLINENO                                                   19270031
         IF (LTR,R1,R1,NM)                                              19280031
           IF (CLI,GETLCRQ,E,0) //LINECOUNT REQ                         19290038
             B GETLCE                                                   19300038
           ENDIF                                                        19310038
         ENDIF                                                          19320031
         XC WLINENO,WLINENO                                             19330031
         XC WMAXMM,WMAXMM                                               19340038
         LA R2,PDSDCB3                                                  19350035
*        OPEN ((R2),(INPUT))                                            19360035
*        IF (TM,DCBOFLGS-IHADCB(R2),DCBOFOPN,NO)                        19370035
*          MVC ERRMSGL1+3(8),DCBDDNAM-IHADCB(R2)                        19380035
*          UERREXIT ERRMSGL1                                            19390035
*        ENDIF                                                          19400035
 ULSNAP 'BEFORE FIND',BLDLFIND                                          19410035
         FIND (R2),BLDLFIND,C                                           19420035
         IF (LTR,R15,R15,NZ)                                            19430031
           MVC ERRMSGL2+3(8),BLDLPNAM                                   19440031
           UERREXIT ERRMSGL2                                            19450034
         ENDIF                                                          19460000
         L R4,MEMBBUFF                                                  19470049
         IF (LTR,R4,R4,Z)                                               19480049
           LH R0,DCBBLKSI-IHADCB(R2)                                    19490049
           ST R0,MEMBBUFL                                               19500049
   ULSNAP 'AFTER FIND'                                                  19510049
           GETMAIN RC,LV=(R0)                                           19520049
           IF (LTR,R15,R15,NZ)                                          19530049
             UERREXIT ERRMSGL3                                          19540049
           ENDIF                                                        19550049
           ST R1,MEMBBUFF                                               19560049
           LR R4,R1                    READ BUFF                        19570049
         ENDIF                                                          19580049
         SR R5,R5                    TOTAL LEN                          19590023
         DO INF                      1/2 TIMES               11A#7558   19600032
           READ DECBMEMB,SF,(R2),(R4),'S' READ REC                      19610035
           CHECK DECBMEMB            WAIT I/O COMPLETION                19620035
           L R1,DECBMEMB+16          IOB ADDR                           19630035
           LH R0,DCBBLKSI-IHADCB(R2)                                    19640032
 ULSNAP 'AFTER READ',((R2),64),((R4),(R0))                              19650035
           SH R0,14(R1)              MINUS RESIDUAL LEN=SHORT BLKSZ     19660032
           IF (CLI,GETLCRQ,NE,0)     MOD LEVEL SEARCH REQUEST           19670038
             BAL R14,GETMM                                              19680038
           ENDIF                                                        19690038
           AR R5,R0                  TOTAL LEN                          19700032
         ENDDO                       1/2 TIMES               11A#7558   19710032
EOFMEMB  DS 0H                                                          19720031
         LH R14,DCBLRECL-IHADCB(R2)   LRECL                             19730023
         SR R4,R4                                                       19740032
         DR R4,R14                    RES AND COUNT                     19750032
 ULSNAP 'LINE COUNT R5'                                                 19760046
*        CLOSE ((R2))                                                   19770035
         LR R1,R5                                                       19780031
         ST R1,WLINENO                                                  19790032
GETLCE   DS 0H                                                          19800031
         IF (CLI,GETLCRQ,NE,0) //MAX MM REQ                             19810038
           L R1,WMAXMM                                                  19820038
         ENDIF                                                          19830038
  ULSNAP 'GETLINEC EXIT'                                                19840035
*                                                                       19850031
         LM  R2,R15,SVRLC+R2*4                                          19860031
         BR R14                                                         19870031
****************                                                        19880031
SVRLC    DS 16F                                                         19890031
WLINENO  DC F'-1'                                                       19900035
WMAXMM   DC F'-1'                                                       19910038
MEMBBUFF DC F'0'                                                        19920049
MEMBBUFL DC F'0'                                                        19930049
GETLCRQ  DC X'00' MAX MOD LEVE SEARCH REQ ID                            19940038
ERRMSGL1 DC CL80' * XXXXXXXX OPEN TO GET LINE COUNT FAILED'             19950031
ERRMSGL2 DC CL80' * XXXXXXXX FIND FAILED'                               19960031
ERRMSGL3 DC CL80' * GETMAIN FOR READ MEMBER FAILED'                     19970031
MEMBDATA DS CL80                                                        19980031
**********************************************************************  19990038
* GET MOD LEVEL FROM RECORD                                    A#002    20000040
* INPUT R2 DCB                                                          20010038
* INPUT R4 RECORD BUFF                                                  20020038
* INPUT R0 BUFFSZ                                                       20030038
**********************************************************************  20040038
GETMM    DS 0H                                                          20050038
         STM R14,R4,SVRGMM                                              20060038
         DO WHILE=(LTR,R0,R0,P)                                         20070038
           LA R1,72(R4)                                                 20080038
           DO FROM=(R14,8)                                              20090038
           DOEXIT (CLI,0(R1),LT,C'0'),OR,(CLI,0(R1),GT,C'9')            20100038
             LA R1,R1(R1)                                               20110038
           ENDDO                                                        20120038
           IF (LTR,R14,R14,Z)                                           20130038
             UATOI 78(R4),LEN=2                                         20140038
     ULSNAP 'GET MM ',((R4),80)                                         20150038
             IF (C,R1,H,WMAXMM)                                         20160038
               ST R1,WMAXMM                                             20170038
             ENDIF                                                      20180038
           ENDIF                                                        20190038
           AH R4,=Y(80)                                                 20200038
           SH R0,=Y(80)                                                 20210038
         ENDDO                                                          20220038
         LM  R14,R4,SVRGMM                                              20230038
         BR R14                                                         20240038
****************                                                        20250038
SVRGMM   DS 7F                                                          20260038
**********************************************************************  20270031
* DATASET INFO GET                                                      20280031
**********************************************************************  20290031
DSINFO   DS 0H                                                          20300031
         ST R14,SVR14DSC                                                20310031
*                                                                       20320023
         OPEN  (PDSDCB,(INPUT))                                         20330023
         IF (TM,DCBOFLGS-IHADCB+PDSDCB,DCBOFOPN,NO)                     20340023
           MVC ERRMSG01+3(8),DCBDDNAM-IHADCB+PDSDCB                     20350023
           LA R0,ERRMSG01                                               20360023
           BAL R14,ERRMSG                                               20370023
         ENDIF                                                          20380023
         LH R1,DCBLRECL-IHADCB+PDSDCB                                   20390023
*        IF (TM,DCBRECFM-IHADCB+PDSDCB,DCBRECF,NO)    RECFM=F  D#006  X 20400067
*              OR,(CH,R1,NE,=Y(80)       NO LIMIT OF 80        D#006    20410067
         IF (TM,DCBRECFM-IHADCB+PDSDCB,DCBRECF,NO)    RECFM=F  A#006    20411067
            MVI SPFSW,0                                                 20420023
         ELSE                                                           20430023
            MVI SPFSW,EQUSPFF   SPF FILE                                20440023
         ENDIF                                                          20450023
*DS INFO                                                                20460023
         LH R1,DCBLRECL-IHADCB+PDSDCB                                   20470023
         UI2Z (R1),HLRECL,LEN=5                                         20480023
         LH R1,DCBBLKSI-IHADCB+PDSDCB                                   20490023
         UI2Z (R1),HBLKSZ,LEN=5                                         20500023
         IF (TM,DCBRECFM-IHADCB+PDSDCB,DCBRECU,O)                       20510023
           MVI HRECFM,C'U'                                              20520023
         ELSE                                                           20530023
           IF (TM,DCBRECFM-IHADCB+PDSDCB,DCBRECF,O)                     20540023
             MVI HRECFM,C'F'                                            20550023
           ELSE                                                         20560023
             IF (TM,DCBRECFM-IHADCB+PDSDCB,DCBRECV,O)                   20570023
               MVI HRECFM,C'V'                                          20580023
             ENDIF                                                      20590023
           ENDIF                                                        20600023
           IF (TM,DCBRECFM-IHADCB+PDSDCB,DCBRECBR,O)                    20610023
             MVI HRECFM+1,C'B'                                          20620023
           ENDIF                                                        20630023
         ENDIF                                                          20640023
         IF (TM,DCBDSORG-IHADCB+PDSDCB,DCBDSGPS,O)                      20650023
           MVC HDSORG,=C'PS'                                            20660023
         ELSE                                                           20670023
           IF (TM,DCBDSORG-IHADCB+PDSDCB,DCBDSGPO,O)                    20680023
             MVC HDSORG,=C'PO'                                          20690023
           ELSE                                                         20700023
             IF (TM,DCBDSORG-IHADCB+PDSDCB,DCBDSGDA,O)                  20710023
               MVC HDSORG,=C'DA'                                        20720023
             ELSE                                                       20730023
               IF (TM,DCBDSORG-IHADCB+PDSDCB,DCBDSGIS,O)                20740023
                 MVC HDSORG,=C'IS'                                      20750023
               ENDIF                                                    20760023
             ENDIF                                                      20770023
           ENDIF                                                        20780023
         ENDIF                                                          20790023
*                                                                       20800023
         CLOSE (PDSDCB)                                                 20810023
*                                                                       20820023
         L R14,SVR14DSC                                                 20830023
         BR R14                                                         20840023
****************                                                        20850023
SVR14DSC DS F                                                           20860023
HDR4     DC CL80' '                                                     20870023
         ORG HDR4                                                       20880023
         DC C'-DSORG='                                                  20890023
HDSORG   DS CL2                                                         20900023
         DC C' RECFM='                                                  20910023
HRECFM   DS CL2                                                         20920023
         DC C' LRECL='                                                  20930023
HLRECL   DS CL5                                                         20940023
         DC C' BLKSIZE='                                                20950023
HBLKSZ   DS CL5                                                         20960023
         ORG                                                            20970023
**********************************************************************  20980030
* GET DIR INFO BY BLDL                                          A#001   20990030
*   PARM: R2 DCB                                                        21000030
*********************************************************************** 21010030
BLDLMEMB DS 0H                                                          21020030
         ST R14,SVR14BLD                                                21030030
*                                                                       21040030
         MVC  BLDLPNAM,PARMMEMB                                         21050030
         BLDL (R2),BLDLPARM                                             21060030
         IF (LTR,R15,R15,NZ)                                            21070030
           MVC ERRMSGNF+21(8),PARMMEMB                                  21080037
           LA R0,ERRMSGNF                                               21090031
           BAL R14,ERRMSG                                               21100030
         ENDIF                                                          21110030
 ULSNAP 'AFTER BLDL',BLDLPENT                                           21120033
         MVC BLDLFIND,BLDLPTTR         SAVE FOR FIND API                21130031
         MVC BLDLPK(SPFISZ+1),BLDLPC   DROP K,Z FLD FOR DIR ENT FORMAT  21140031
 ULSNAP 'AFTER BLDL2',BLDLPENT                                          21150033
*                                                                       21160030
         L R14,SVR14BLD                                                 21170030
         BR R14                                                         21180030
****************                                                        21190030
SVR14BLD DS F                                                           21200030
ERRMSGNF DC CL80' * MEMBER NOT FOUND (XXXXXXXX)'                        21210037
BLDLPARM DS 0F                                                          21220030
         DC H'1'         COUNT                                          21230030
         DC H'62'        ENTRY LEN                                      21240030
BLDLPENT DC XL62'00'                                                    21250034
         ORG BLDLPENT                                                   21260030
BLDLPNAM DS CL8                                                         21270030
BLDLPTTR DS CL3                                                         21280030
BLDLPK   DS CL1          CONCATINATION                                  21290031
BLDLPZ   DS CL1                                                         21300030
BLDLPC   DS CL1                                                         21310030
BLDLPUSR DS 0C                                                          21320030
*                                                                       21330031
         ORG                                                            21340033
BLDLFIND DS CL4          TTRC                                           21350031
**********************************************************************  21360001
* PARM D/S ALLOCATION                                                   21370006
*********************************************************************** 21380006
DSALLOC  DS 0H                                                          21390006
         ST R14,SVR14DAI                                                21400006
*                                                                       21410006
         IF (CLI,WFUNCID,E,EQFSPFUP)                              A#002 21420030
           MVI #S99DISP,EQDOLD                   DISP=OLD       A#002   21430030
         ENDIF                                                  A#002   21440030
         MVI DCBID,C'1'                                                 21450010
         LA R1,#S99RBX1             POINT 20BYTES BYND RBPTR TOP        21460006
         BAL R14,DYNALLOC                                               21470006
         MVI SWDSALOK,1                                         A#004   21471062
*                                                                       21480006
         L R14,SVR14DAI                                                 21490006
         BR R14                                                         21500006
****************                                                        21510006
SVR14DAI DS F                                                           21520006
SWDSALOK DC X'00'                                               A#004   21521062
#S99RBX1 DS   0F                       DSECT HAS NO LENGTH EQU          21530006
         DC   A(#S99TDSN)                                               21540006
         DC   A(#S99TDDN)                                               21550006
         DC   A(#S99TDSP+X'80000000')                                   21560006
#S99TDSN DS   0F                                                        21570006
         DC   AL2(DALDSNAM),AL2(1)                                      21580006
PARMDSNL DC   AL2(8)                                                    21590006
PARMDSN  DC   CL44' '                                                   21600006
#S99TDSP DS   0F                                                        21610006
         DC   AL2(DALSTATS),AL2(1)                                      21620006
         DC   AL2(1)                                                    21630006
#S99DISP DC   AL1(8)                   DISP=SHR                         21640030
EQDOLD   EQU  X'01'                     DISP=OLD                        21650030
#S99TDDN DS   0F                                                        21660006
         DC   AL2(DALRTDDN),AL2(1)                                      21670006
         DC   AL2(8)                                                    21680006
RETDDN   DC   CL8' '                                                    21690006
**********************************************************************  21700000
* SYSOUT   ALLOCATION                                                   21710006
*********************************************************************** 21720006
SOALLOC  DS 0H                                                          21730006
         ST R14,SVR14DAO                                                21740006
*                                                                       21750006
         IF (CLI,TSOJOBID,NE,0)       UNDER TSO                         21760011
           LA R1,#S99RBX3             POINT 20BYTES BYND RBPTR TOP      21770000
         ELSE                                                           21780000
           LA R1,#S99RBX2             POINT 20BYTES BYND RBPTR TOP      21790006
         ENDIF                                                          21800000
         MVI DCBID,C'2'                                                 21810010
         BAL R14,DYNALLOC                                               21820006
*                                                                       21830006
         L R14,SVR14DAO                                                 21840006
         BR R14                                                         21850006
****************                                                        21860006
SVR14DAO DS F                                                           21870006
#S99RBX2 DS   0F                       SYSOUT ALL                       21880000
         DC   A(#S99TSOT)                                               21890006
         DC   A(#S99TDDN+X'80000000')                                   21900006
#S99RBX3 DS   0F                       TERMINAL ALLOCATION              21910000
         DC   A(#S99TTRM)                                               21920000
         DC   A(#S99TDDN+X'80000000')                                   21930000
#S99TSOT DS   0F                                                        21940006
         DC   AL2(DALSYSOU),AL2(0)     COUNT=0:DEFAULT CLASS            21950012
*        DC   AL2(1)                                                    21960012
*        DC   C'A'                     SYSOUT=A                         21970012
#S99TTRM DS   0F                                                        21980006
         DC   AL2(DALTERM),AL2(0)     TSO TERMINAL                      21990006
**********************************************************************  22000000
CLOSEFRE DS 0H                                                          22010000
         ST R14,SVR14CF                                                 22020000
         L R2,MEMBBUFF                                                  22030049
         L R0,MEMBBUFL                                                  22040050
         IF (LTR,R2,R2,NZ)                                              22050049
           FREEMAIN RU,A=(R2),LV=(R0)                                   22060049
         ENDIF                                                          22070049
         LA R2,PDSDCB2                                                  22080000
         IF (TM,DCBOFLGS-IHADCB(R2),DCBOFOPN,O)                         22090000
           CLOSE ((R2))                                                 22100000
         ENDIF                                                          22110000
         LA R2,PDSDCB3                                                  22120030
         IF (TM,DCBOFLGS-IHADCB(R2),DCBOFOPN,O)                         22130030
           CLOSE ((R2))                                                 22140030
         ENDIF                                                          22150030
         IF (CLI,DCBDDNAM-IHADCB(R2),NE,C' ')  //ALLOCATED              22160000
           MVC UNALDDNM,DCBDDNAM-IHADCB(R2)                             22170000
           MVI DCBDDNAM-IHADCB(R2),C' '                                 22180011
           MVI DCBID,C'1'                                               22190011
           LA R1,#S99RBX4             POINT 20BYTES BYND RBPTR TOP      22200000
           BAL R14,DYNAFREE                                             22210000
         ENDIF                                                          22220000
         LA R2,OUTDCB                                                   22230000
         IF (TM,DCBOFLGS-IHADCB(R2),DCBOFOPN,O)                         22240000
           CLOSE ((R2))                                                 22250000
         ENDIF                                                          22260000
* TSO:UNALLOC FAIL, BATCH:SYSOUT GONE ANYWHERE                          22270012
*        IF (CLI,TSOJOBID,E,0)  UNDER TSO                               22280012
*            IF (CLI,DCBDDNAM-IHADCB(R2),NE,C' ')  //ALLOCATED          22290012
*              MVC UNALDDNM,DCBDDNAM-IHADCB(R2)                         22300012
*              MVI DCBDDNAM-IHADCB(R2),C' '                             22310012
*              MVI DCBID,C'2'                                           22320012
*              LA R1,#S99RBX4             POINT 20BYTES BYND RBPTR TOP  22330012
*              BAL R14,DYNAFREE                                         22340012
*            ENDIF                                                      22350012
*        ENDIF                                                          22360012
         L R14,SVR14CF                                                  22370000
         BR R14                                                         22380000
*******************************                                         22390000
SVR14CF  DS F                                                           22400000
#S99RBX4 DS   0F                       SYSOUT ALL                       22410000
         DC   A(#S99TUDD+X'80000000')                                   22420011
#S99TUDD DS   0F                                                        22430000
         DC   AL2(DUNDDNAM),AL2(1)     UNALLOCATION DDNAME              22440000
         DC   AL2(8)                                                    22450000
UNALDDNM DC   CL8' '                   DDNAME                           22460000
**********************************************************************  22470000
* DYNALOC SUB                                                           22480006
* PARM R1:TEXT UNIT LIST                                                22490006
*********************************************************************** 22500006
DYNALLOC DS 0H                                                          22510006
         ST R14,SVR14DA                                                 22520006
         LA    R4,#S99RB                                                22530006
         XC    S99RB(#S99RBSZ),S99RB   ZERO CLEAR RB ENTIRELY           22540006
         MVI   S99RBLN,#S99RBSZ        SET RB LNGTH IN ITS LNGTH FLD    22550006
         MVI   S99VERB,S99VRBAL        SET VERB CODE                    22560006
         MVI   S99FLG11,S99NOMNT       NO MOUNT                         22570006
         ST    R1,S99TXTPP             SET TXT PNTRS INTO RB            22580006
*                                                                       22590006
         LA    R1,#S99RBPT             ADDR OF PARAMETER AREA           22600006
         DYNALLOC                                                       22610006
         IF (LTR,R15,R15,NZ)                    DYNALLOC ERR            22620006
           BAL R14,DYNAERR                                              22630000
         ENDIF                                                          22640006
*                                                                       22650006
         L R14,SVR14DA                                                  22660006
         BR R14                                                         22670006
*******************************                                         22680006
SVR14DA  DS F                                                           22690006
#S99RBPT DC   A(#S99RB+X'80000000')                                     22700006
#S99RB   DS   CL256 (#S99RBSZ)                                          22710006
**********************************************************************  22720000
* DYNALOC SUB                                                           22730000
* PARM R1:TEXT UNIT LIST                                                22740000
*********************************************************************** 22750000
DYNAFREE DS 0H                                                          22760000
         ST R14,SVR14DF                                                 22770000
         IF (CLI,SWDSALOK,E,0)                             A#004        22770262
            BR R14                                         A#004        22770362
         ENDIF                                             A#004        22771059
         LA    R4,#S99RB                                                22780000
         XC    S99RB(#S99RBSZ),S99RB   ZERO CLEAR RB ENTIRELY           22790000
         MVI   S99RBLN,#S99RBSZ        SET RB LNGTH IN ITS LNGTH FLD    22800000
         MVI   S99VERB,S99VRBUN        SET VERB CODE/UNALLOCATION       22810000
         ST    R1,S99TXTPP             SET TXT PNTRS INTO RB            22820000
*                                                                       22830000
         LA    R1,#S99RBPT             ADDR OF PARAMETER AREA           22840000
         DYNALLOC                                                       22850000
         IF (LTR,R15,R15,NZ)                    DYNALLOC ERR            22860000
           BAL R14,DYNAERR                                              22870000
         ENDIF                                                          22880000
*                                                                       22890000
         L R14,SVR14DF                                                  22900000
         BR R14                                                         22910000
*******************************                                         22920000
SVR14DF  DS F                                                           22930000
**********************************************************************  22940000
* DYNALOC ERRMSG                                                        22950000
* PARM R1:TEXT UNIT LIST                                                22960000
*********************************************************************** 22970000
DYNAERR  DS 0H                                                          22980000
         ST R14,SVR14DE                                                 22990000
         UI2X (R15),ERRMSG05+15,LEN=2                                   23000012
         L R0,S99RSC                                                    23010000
         UI2X (R0),ERRMSG05+18                                          23020012
         IF (CLI,S99VERB,EQ,S99VRBAL)        ALLOC                      23030008
           MVC ERRMSG05+3(8),=C'DYNALLOC'                               23040018
           IF (CLC,S99TXTPP,E,=A(#S99RBX1))     DS ALLOC                23050008
             MVC ERRMSG05+27(44),PARMDSN                                23060012
           ELSE                                                         23070008
             MVC ERRMSG05+27(44),BLANK                                  23080012
             MVC ERRMSG05+27(6),=C'SYSOUT'                              23090012
           ENDIF                                                        23100008
           IF (CLC,S99ERROR,EQ,=X'1708')                                23110010
             MVC ERRMSG05+3(8),=C'NOT-CAT '                             23120012
           ENDIF                                                        23130010
           IF (CLC,S99ERROR,EQ,=X'020C'),                              X23140010
               OR,(CLC,S99ERROR,EQ,=X'0210')                            23150010
             MVC ERRMSG05+3(8),=C'IN-USE  '                             23160012
           ENDIF                                                        23170010
         ELSE                                                           23180008
           MVC ERRMSG05+3(8),=C'DYNAFREE'                               23190018
           IF (CLI,DCBID,E,C'1')                                        23200010
             MVC ERRMSG05+27(44),PARMDSN                                23210012
           ELSE                                                         23220010
             MVC ERRMSG05+27(44),BLANK                                  23230012
             MVC ERRMSG05+27(6),=C'SYSOUT'                              23240012
           ENDIF                                                        23250011
         ENDIF                                                          23260008
         LA R0,ERRMSG05                                                 23270009
         BAL R14,ERRMSG                                                 23280000
*                                                                       23290000
         L R14,SVR14DE                                                  23300000
         BR R14                                                         23310000
*******************************                                         23320000
SVR14DE  DS F                                                           23330000
ERRMSG05 DC    CL80' * XXXXXXXX RC=XX:XXXXXXXX X'                       23340012
**********************************************************************  23350027
DISPHDR  DS 0H                                                          23360027
         ST R14,SVR14DH                                                 23370027
*                                                                       23380027
         LA R0,HDR1                                                     23390027
         BAL R14,PUTOUT                                                 23400027
         LA R0,HDR4                                                     23410027
         BAL R14,PUTOUT                                                 23420027
         LA R0,HDR2                                                     23430027
         BAL R14,PUTOUT                                                 23440027
*                                                                       23450027
         L R14,SVR14DH                                                  23460027
         BR R14                                                         23470027
SVR14DH  DS F                                                           23480027
**********************************************************************  23490006
DISPMEMB DS 0H                                                          23500006
         ST R14,SVR14                                                   23510006
         IF (TM,PDS2INDC,PDS2ALIS,O)                                    23520030
            OI SPFSW,EQUALIAS  SPF INFO EXIST                           23530030
         ELSE                                                           23540030
            NI SPFSW,X'FF'-EQUALIAS  SPF INFO EXIST                     23550030
         ENDIF                                                          23560030
         IF (CLI,PDS2INDC,EQ,PDS2SPFI) SPF INFO DATA LEN=X0F(30 BYTE)   23570030
            OI SPFSW,EQUSPFI   SPF INFO EXIST                           23580030
         ELSE                                                           23590030
            NI SPFSW,X'FF'-EQUSPFI   SPF INFO EXIST                     23600034
            IF (CLI,PDS2INDC,NE,0)   OTHER DIR INFOO                    23610034
              OI SPFSW,EQUOTHER  SPF INFO EXIST                         23620035
            ELSE                                                        23630034
              NI SPFSW,X'FF'-EQUOTHER  SPF INFO EXIST                   23640034
            ENDIF                                                       23650034
         ENDIF                                                          23660030
         MVI WKSPFINF,C' '                                              23670006
         MVC WKSPFINF+1(L'WKSPFINF-1),WKSPFINF                          23680006
*MEMBER NAME                                                            23690020
         IF (CLI,DISPUPDT,E,0)                                          23700046
           MVC WKSPFNAM,PDS2NAME                                        23710006
         ELSE                                                           23720046
           MVC WKSPFNAM,=C'=======>'                                    23730000
         ENDIF                                                          23740046
         MVI WKSPFVV,EQUVERNO          NO SPF DATA                      23750024
         IF (TM,SPFSW,EQUALIAS,O)                                       23760021
           MVC WKSPFVV(5),=C'ALIAS '      ALIAS                         23770021
           L R14,ALIASNO                                                23780022
           LA R14,1(R14)                                                23790022
           ST R14,ALIASNO                                               23800022
         ENDIF                                                          23810020
       IF (TM,SPFSW,EQUSPFF+EQUSPFI,O) RECFM=F,LRECL=80,UDATALEN=0F     23820006
*VVMM                                                                   23830000
         SR R2,R2                                                       23840000
         IC R2,SPFVV                                                    23850001
         UI2Z (R2),WKSPFVV,LEN=2                                        23860000
         MVI WKSPFVV+2,C'.'                                             23870000
         SR R2,R2                                                       23880000
         IC R2,SPFMM                                                    23890001
         UI2Z (R2),WKSPFMM,LEN=2                                        23900000
*CRE DATE                                                               23910000
       IF (OC,SPFCRD,SPFCRD,NZ)                                         23920039
         MVC WKDATE(4),SPFCRD                                           23930001
         UDATE WKDATE,TODAY=N,INPUT=J,TBL=N  R0=00YYMMDD                23940000
         IF (LTR,R15,R15,Z)                                             23950042
           MVC WKSPFCRD(2),WKDATE                                       23960042
           MVI WKSPFCRD+2,C'/'                                          23970042
           MVC WKSPFCRD+3(2),WKDATE+2                                   23980042
           MVI WKSPFCRD+5,C'/'                                          23990042
           MVC WKSPFCRD+6(2),WKDATE+4                                   24000042
         ELSE                                                           24010042
           MVC WKSPFCRD(8),=C'??/??/??'                                 24020042
         ENDIF                                                          24030042
       ELSE                                                             24040042
         MVC WKSPFCRD(8),=C'00/00/00'                                   24050042
       ENDIF                                                            24060039
*CHG DATE                                                               24070000
       IF (OC,SPFCHD,SPFCHD,NZ)                                         24080039
         MVC WKDATE(4),SPFCHD                                           24090001
         UDATE WKDATE,TODAY=N,INPUT=J,TBL=N  R0=00YYMMDD                24100000
         IF (LTR,R15,R15,Z)                                             24110042
           MVC WKSPFCHD(2),WKDATE                                       24120042
           MVI WKSPFCHD+2,C'/'                                          24130042
           MVC WKSPFCHD+3(2),WKDATE+2                                   24140042
           MVI WKSPFCHD+5,C'/'                                          24150042
           MVC WKSPFCHD+6(2),WKDATE+4                                   24160042
         ELSE                                                           24170042
           MVC WKSPFCHD(8),=C'??/??/??'                                 24180042
         ENDIF                                                          24190042
       ELSE                                                             24200042
         MVC WKSPFCHD(8),=C'00/00/00'                                   24210042
       ENDIF                                                            24220039
*CHG TIME                                                               24230000
         LH R2,SPFCHT                                                   24240001
         UI2X (R2)                                                      24250000
         MVC WKSPFCHT(2),4(R1)                                          24260000
         MVI WKSPFCHT+2,C':'                                            24270000
         MVC WKSPFCHT+3(2),6(R1)                                        24280000
         SR R2,R2                                       A#011           24280124
         IC R2,SPFCHTS           UPDATE TIME SECONDS    A#011           24281024
         UI2X (R2)                                      A#011           24282024
         MVI WKSPFCHT+5,C':'                            A#011           24284024
         MVC WKSPFCHT+6(2),6(R1)                        A#011           24285024
*CUR SIZE                                                               24290000
         LH R2,SPFCLNO                                                  24300001
         UI2ZE (R2),WKSPFCSZ,LEN=11                                     24310013
*INI SIZE                                                               24320000
         LH R2,SPFILNO                                                  24330001
         UI2ZE (R2),WKSPFISZ,LEN=11                                     24340013
*UPD SIZE                                                               24350000
*        LH R2,DIRUSZ                                                   24360001
*        UI2ZE (R2),WKSPFUSZ,LEN=7                                      24370001
*USERID                                                                 24380000
         MVC WKSPFUID,SPFUSR                                            24390039
         IF (CLC,SPFUSR,E,BLANK)                                        24400039
           MVI WKSPFUID,C'-'       SEE IT                               24410039
         ENDIF                                                          24420039
       ENDIF                                                            24430004
*                                                                       24440001
         LA R0,WKSPFINF                                                 24450004
         BAL R14,PUTOUT                                                 24460008
         IF (CLI,DISPUPDT,E,0)                                          24470046
           L R14,LINENO                                                 24480017
           LA R14,1(R14)                                                24490017
           ST R14,LINENO                                                24500017
         ENDIF                                                          24510046
*                                                                       24520001
EXITDM   DS 0H                                                          24530017
         L R14,SVR14                                                    24540001
         BR R14                                                         24550001
*********                                                               24560000
SVR14    DS F                                                           24570001
DISPUPDT DC X'00'         UPDATED LINE DISPLAY REQ ID                   24580046
LINENO   DC F'0'                                                        24590017
ALIASNO  DC F'0'                                                        24600022
HDR1     DC CL80'MEMBER LIST FOR '                                      24610015
HDR2     DC CL80' '                                                     24620015
         ORG HDR2                                                       24630015
         DC CL8'-NAME---'                                               24640019
*        DS CL2                                  D#007                  24650019
         DS CL3                                  A#007                  24651019
         DC CL5'VV.MM'                                                  24660015
         DS CL2                                                         24670015
         DC CL8'CREATED'  CREATION DATE     YY/MM/DD                    24680016
         DS CL2                                                         24690015
         DC CL14'LAST-UPDATED'                                          24700026
         DS CL3                             :SS         A#011           24701024
         DS CL2                                                         24710015
         DC CL11' LINE-COUNT'                                           24720026
         DS CL1                                                         24730015
         DC CL11'    INITIAL'                                           24740022
         DS CL2                                                         24750015
         DC CL8'USERID'                                                 24760015
*        DS CL4                                       D#007             24770019
*        DS CL3                                       A#007  D#011      24771024
         ORG                                                            24780015
*********************************************************************** 24790000
* GET EXE PGM NAME                                                      24800000
*********************************************************************** 24810000
GETTJID  DS 0H                                                          24820000
         ST R14,SVR14TS                                                 24830000
         L R14,16                                                       24840000
         L R14,0(R14)                                                   24850000
         L R14,4(R14)      CURR TCB                                     24860000
         L R14,TCBJSCB-TCB(R14)  JSCB                                   24870000
         L R0,JSCBPSCB-IEZJSCB(R14)   TSO PROTECTED STEP CONTROL        24880012
         IF (LTR,R0,R0,NZ)                                              24890012
           MVI TSOJOBID,1                                               24900011
         ENDIF                                                          24910011
         L R14,SVR14TS                                                  24920000
         BR R14                                                         24930000
SVR14TS  DS F                                                           24940000
**********************************************************************  24950004
* ERRMSG PRINT                                                          24960004
*   PARM R0:MSG TEXT                                                    24970006
*********************************************************************** 24980004
ERRMSG   DS 0H                                                          24990004
         BAL R14,PUTOUT                                                 25000000
         LA R15,8                                                       25010000
         B EXIT                                                         25020000
**********************************************************************  25030000
* ERRMSG PRINT                                                          25040000
*   PARM R0:MSG TEXT                                                    25050000
*********************************************************************** 25060000
PUTOUT   DS 0H                                                          25070000
         ST R14,SVR14PO                                                 25080000
         ST R0,SVR0PO                                                   25090035
         IF (TM,DCBOFLGS-IHADCB+OUTDCB,DCBOFOPN,O) OPEND                25100036
           PUT OUTDCB,(R0)                                              25110035
         ENDIF                                                          25120035
         IF (TM,DCBOFLGS-IHADCB+OUTDCB,DCBOFOPN,NO),                   X25130035
               OR,(CLI,WTOREQ,NE,0)                                     25140035
           L R14,SVR0PO                                                 25150035
           MVC WTOMSG01+4(80),0(R14)                                    25160000
           WTO MF=(E,WTOMSG01)                                          25170000
         ENDIF                                                          25180012
         L R14,SVR14PO                                                  25190000
         BR R14                                                         25200000
SVR14PO  DS F                                                           25210000
SVR0PO   DS F                                                           25220035
WTOREQ   DC X'00'                                                       25230035
**********************************************************************  25240001
* ESTAE SETUP                                                           25250001
*   RET R0:PARM,R1:PARM,R2:MACNAME                                      25260001
*********************************************************************** 25270001
PXMSESTS DS 0H                                                          25280001
         ST R14,SVR14E                                                  25290001
         L R2,=A(PXMSESTX)                                              25300001
         LA R3,ESTPRM                                                   25310001
*                                                                       25320001
         ESTAE (R2),CT,PARAM=(R3),         * ESTAE RTN. E.P            +25330001
               XCTL=NO,PURGE=NONE,ASYNCH=YES,TERM=YES                   25340001
         L R14,SVR14E                                                   25350001
         BR R14                                                         25360001
ESTPRM   DC F'0'                                                        25370001
SVR14E   DS F                                                           25380001
**********************************************************************  25390001
*ESTAE EXIT                                                             25400001
*********************************************************************** 25410001
PXMSESTX DS 0D                                                          25420001
         DROP R9,R10,R11,R12                                            25430034
         USING PXMSESTX,R15                                             25440001
         STM R0,R15,##ESTREG                                            25450001
*                                                                       25460001
         LM R9,R12,##ESTBS2                                             25470008
         DROP R15                                                       25480034
         USING XE4S001Z,R12,R11,R10,R9                                  25490034
*                                                                       25500001
         USING SDWA,R5                                                  25510004
*                                                                       25520001
         LR R8,R0                PROC ID                                25530001
         LR R5,R1                SAWA /COMPCODE                         25540004
         LA R13,##ESTXSA                                                25550001
*                                                                       25560001
         MVI WTOREQ,1             ALSO WTO                              25570035
         IF (C,R8,NE,=F'12')       SDWA NOT OBTAINED                    25580004
           L R7,SDWAPARM         8BYTE COPY OF MODIFTABLE AREA          25590001
           L R4,SDWAABCC                                                25600001
         ELSE                                                           25610001
           LR R7,R2               PARM JOB ENTRY                        25620001
           LR R4,R5               COMPCD                                25630004
         ENDIF                                                          25640001
*                                                                       25650001
         IF (C,R8,NE,=F'12')       SDWA NOT OBTAINED                    25660004
           L R2,=A(WKMSG45)                                             25670001
         ELSE                                                           25680001
           L R2,=A(WKMSG46)                                             25690001
         ENDIF                                                          25700001
         UI2X (R4),39(R2)                                               25710050
         LR R0,R2                                                       25720004
         BAL R14,PUTOUT                                                 25730004
*PSW,OFFS                                                               25740032
         IF (C,R8,NE,=F'12')       SDWA NOT OBTAINED                    25750032
           L R2,SDWAEC1                                                 25760032
           UI2X (R2),WKMSG47+8                                          25770032
           L R2,SDWAEC1+4                                               25780032
           UI2X (R2),WKMSG47+17                                         25790032
           LA R1,0(R2)                                                  25800032
           LA R0,0(R12)                                                 25810032
           SR R1,R0                                                     25820032
           UI2X (R1),WKMSG47+31                                         25830032
           LA R0,WKMSG47                                                25840032
           BAL R14,PUTOUT                                               25850004
*REG                                                                    25860050
           DO FROM=(R2,4)                                               25870050
             LA R14,4                                                   25880050
             SR R14,R2                                                  25890050
             SLL R14,2                                                  25900050
             UI2Z (R14),WKMSG48+4,LEN=2                                 25910050
             LA R15,3(R14)                                              25920050
             UI2Z (R15),WKMSG48+8,LEN=2                                 25930050
             SLL R14,2                                                  25940050
             LA R14,SDWAGR00(R14)    STRAT REG                          25950050
             L R15,0(R14)                                               25960050
             UI2X  (R15),WKMSG48++12                                    25970050
             L R15,4(R14)                                               25980050
             UI2X  (R15),WKMSG48++21                                    25990050
             L R15,8(R14)                                               26000050
             UI2X  (R15),WKMSG48++30                                    26010050
             L R15,12(R14)                                              26020050
             UI2X (R15),WKMSG48++39                                     26030050
             LA R0,WKMSG48                                              26040050
             BAL R14,PUTOUT                                             26050050
           ENDDO                                                        26060050
         ENDIF                                                          26070001
 ULSNAP 'ESTAE'                                                         26080034
         LA R2,OUTDCB                                                   26090034
         IF (TM,DCBOFLGS-IHADCB(R2),DCBOFOPN,O)                         26100034
           CLOSE ((R2))                                                 26110034
         ENDIF                                                          26120034
*                                                                       26130001
         IF (C,R8,NE,=F'12')      SDWA NOT OBTAINED                     26140004
           LR R1,R5                                                     26150004
           SETRP RC=0                                                   26160001
         ENDIF                                                          26170001
         SR R15,R15                                                     26180001
         LM R0,R14,##ESTREG                                             26190001
         BR R14                                                         26200001
*********************************************************************** 26210001
##ESTBS2 DC A(XE4S001Z+4096+4096+4096)  R9                              26220008
         DC A(XE4S001Z+4096+4096)       R10                             26230008
         DC A(XE4S001Z+4096)            R11                             26240008
         DC A(XE4S001Z)                 R12                             26250008
##ESTREG DS 16F                                                         26260001
##ESTXSA DS 18F                                                         26270001
WKMSG45  DC CL80' * XE4S001Z:ENTERED ESTAE WITH SDWA,CC=12345678'       26280050
WKMSG46  DC CL80' * XE4S001Z:ENTERED ESTAE W/O  SDWA,CC=12345678'       26290050
WKMSG47  DC CL80' * PSW= 12345678 12345678 OFFS=12345678'               26300032
WKMSG48  DC CL80' * RXX-RXX: 12345678 12345678 12345678 12345678'       26310050
************************************************************            26320001
***      AREA DEFINE                                     ***            26330001
************************************************************            26340001
MVCHDR1  MVC   HDR1+16(0),0(R1)                                   R#002 26350030
         LTORG                                                          26360006
SAVEA    DS    18F                     * REGISTER SAVE AREA             26370011
BLANK    DC    CL256' '                                                 26380011
WTOMSG01 WTO   '.........1.........2.........3.........4.........5.....X26390006
               ...6.........7.........8',MF=L                           26400006
ERRMSG01 DC    CL80' * XXXXXXXX PDS OPEN FAILED.'                       26410004
ERRMSG02 DC    CL80' * XXXXXXXX DIRECTORY OPEN FAILED.'                 26420004
ERRMSG03 DC    CL80' * DSNAME PARAMETER MISSING'                        26430006
ERRMSG04 DC    CL80'XXXXXXXX (PRINT OUT DCB) OPEN FAILED'               26440000
ERRMSG06 DC    CL80' * PARAMETER FORMAT ERR(DSN OR MEMBERNAME LENGTH)'  26450017
*RRMSG08 DC    CL80' * PARM ERR:MISSING MEMBER NAME'                    26460044
ERRMSG09 DC    CL80' * OPERATION ALLOWED ONLY FOR DATASET WITH RECFM=F(+26470030
               B) LRECL=80'                                             26480030
SPFSW    DC    X'00'                                                    26490004
EQUSPFF  EQU   X'01'                                                    26500004
EQUSPFI  EQU   X'02'                                                    26510004
EQUALIAS EQU   X'04'                                                    26520021
EQUOTHER EQU   X'08'                                                    26530034
DCBID    DC C'0'                                                        26540011
TSOJOBID DC X'0'                                                        26550011
*                                                                       26560011
PDSDCB   DCB   DSORG=PO,MACRF=(R),DDNAME=XE4S001I EXLST=EXL             26570012
PDSDCB2  DCB   DSORG=PS,MACRF=R,DDNAME=XE4S001I,RECFM=U,BLKSIZE=256,   +26580012
               EODAD=EOFDIR                                             26590001
PDSDCB3  DCB   DSORG=PO,DEVD=DA,DDNAME=XE4S001I,MACRF=(R,W),           +26600030
               EODAD=EOFMEMB                                            26610031
OUTDCB   DCB   DSORG=PS,MACRF=(PM),DDNAME=XE4S001O,RECFM=F,            X26620012
               LRECL=80,BLKSIZE=80                                      26630001
WKDATE   DS CL6                                                         26640000
DIRAREA  DS CL256                                                       26650000
                                                                        26660004
WKSPFINF DC CL80' '                                                     26670004
         ORG WKSPFINF                                                   26680004
         DS CL1           KEEP SPACE FOR THE CASE MEMBERNAME=READY      26690051
WKSPFNAM DS CL8           MEMBER NAME                                   26700014
         DS CL2                                                         26710021
WKSPFVV  DS CL2           VERSION                                       26720004
EQUVERNO EQU C'-'         NO SPF INFO ID ON VERSION FLD                 26730024
         DC CL1'.'                                                      26740013
WKSPFMM  DS CL2           MODIFIER                                      26750004
         DS CL2                                                         26760006
WKSPFCRD DC CL8'YY/MM/DD' CREATION DATE     YY/MM/DD                    26770006
         DS CL2                                                         26780006
WKSPFCHD DC CL8'YY/MM/DD' LAST CHANGED DATE YY/MM/DD                    26790006
         DS CL1                                                         26800006
*KSPFCHT DC CL5'HH:MM'    LAST CHANGED TIME HH:MM              D#011    26810024
WKSPFCHT DC CL8'HH:MM:SS' LAST CHANGED TIME HH:MM              A#011    26811024
         DS CL2                                                         26820006
WKSPFCSZ DS CL11          CURRENT LINE SIZE NNN,NNN,NNN                 26830013
         DS CL1                                                         26840013
WKSPFISZ DS CL11          INIT    LINE SIZE NNN,NNN,NNN                 26850013
         DS CL2                                                         26860006
WKSPFUID DS CL8           USERID                                        26870006
*        DS CL3                                               D#011     26880024
         ORG                                                            26890006
*                                                                       26900000
********************************************************************    26910000
PDS2     DSECT                                                          26920001
PDS2NAME DS CL8                                                         26930001
PDS2TTRP DS CL3                                                         26940001
PDS2INDC DS CL1                                                         26950001
PDS2ALIS EQU X'80'    ALIAS                                             26960020
PDS2LUSR EQU X'1F'    MASK OF USER DATA LENGTH BY HALF WORD             26970020
PDS2SPFI EQU X'0F'    SPF DATA LEN                                      26980020
PDS2USRD DS 0C                                                          26990001
SPFVV    DS CL1                                                         27000001
SPFMM    DS CL1                                                         27010001
*SPFRSV1  DS CL2                               D#009                    27020021
SPFRSV1  DS CL1                                A#009                    27021021
SPFCHTS  DS CL1     CHG TIME:SECONDS           A#009                    27022021
SPFCRD   DS CL4     CRE DATE                                            27030001
SPFCHD   DS CL4     CHG DATE                                            27040001
SPFCHT   DS CL2     CHD TIME                                            27050001
SPFCLNO  DS CL2     CUR LINE COUNT                                      27060001
SPFILNO  DS CL2     INIT LINE COUNT                                     27070001
SPFRSV2  DS CL2                                                         27080033
SPFUSR   DS CL8     USER ID                                             27090001
SPFRSV3  DS CL2                                                         27100033
SPFISZ   EQU *-PDS2USRD                                                 27110030
DIRESZ   EQU *-PDS2                                                     27120001
********                                                                27130000
*                                                                       27140000
         PRINT NOGEN                                                    27150001
         DCBD  DSORG=PS                                                 27160000
         IHASDWA                                                        27170004
         IKJTCB                                                         27180000
         IEFZB4D0         , DYNALOC RB                                  27190006
         IEFZB4D2         , DYNALOC KEY                                 27200006
#S99RBSZ EQU S99RBEND-S99RB                                             27210006
         IEZJSCB                                                        27220012
         END                                                            27230000
