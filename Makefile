QCC_OBJS=qccmain.o qcc_cmdlib.o qcc_pr_comp.o qcc_pr_lex.o comprout.o hash.o qcd_main.o
GTKGUI_OBJS=qcc_gtk.o qccguistuff.c
LIB_OBJS=

CC=gcc -Wall -DQCCONLY

DO_CC=$(CC) $(BASE_CFLAGS) -o $@ -c $< $(CFLAGS)

all: qcc

BASE_CFLAGS=-ggdb
CFLAGS =

lib: 

win_nocyg: $(QCC_OBJS) qccgui.c qccguistuff.c
	$(CC) $(BASE_CFLAGS) -o fteqcc.exe -O3 -s $(QCC_OBJS) -mno-cygwin -mwindows
nocyg: $(QCC_OBJS) qccgui.c qccguistuff.c
	$(CC) $(BASE_CFLAGS) -o fteqcc.exe -O3 -s $(QCC_OBJS) -mno-cygwin
win: $(QCC_OBJS) qccgui.c qccguistuff.c
	$(CC) $(BASE_CFLAGS) -o fteqcc.exe -O3 -s $(QCC_OBJS) -mwindows
qcc: $(QCC_OBJS)
	$(CC) $(BASE_CFLAGS) -o fteqcc.bin -O3 -s $(QCC_OBJS)

qccmain.o: qccmain.c qcc.h
	$(DO_CC)

qcc_cmdlib.o: qcc_cmdlib.c qcc.h
	$(DO_CC)

qcc_pr_comp.o: qcc_pr_comp.c qcc.h
	$(DO_CC)

qcc_pr_lex.o: qcc_pr_lex.c qcc.h
	$(DO_CC)

comprout.o: comprout.c qcc.h
	$(DO_CC)

hash.o: hash.c qcc.h
	$(DO_CC)

qcd_main.o: qcd_main.c qcc.h
	$(DO_CC)

qccguistuff.o: qccguistuff.c qcc.h
	$(DO_CC)

qcc_gtk.o: qcc_gtk.c qcc.h
	$(DO_CC) `pkg-config --cflags gtk+-2.0`

gtkgui: $(QCC_OBJS) $(GTKGUI_OBJS)
	$(CC) $(BASE_CFLAGS) -DQCCONLY -DUSEGUI -o fteqccgui.bin -O3 $(GTKGUI_OBJS) $(QCC_OBJS) `pkg-config --libs gtk+-2.0`
