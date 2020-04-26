default: netlogo
	gcc netlogo.lex.c -o netlogo -lfl

netlogo: netlogoLang.l
	flex -o netlogo.lex.c netlogoLang.l

cleanWindows:
	del netlogo.exe
	del netlogo.lex.c


cleanUnix:
	rm -f netlogo
	rm -f netlogo.lex.c
