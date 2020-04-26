.PHONY: default

FILES_TO_DELETE = agentSpeak.tab.c agentSpeak.lex.c agentSpeak.output agentSpeak


default: agentSpeak

agentSpeak: agentSpeak.lex.c agentSpeak.tab.c
	gcc -o agentSpeak agentSpeak.tab.c -lfl

agentSpeak.lex.c: agentSpeak.l
	flex -s -o agentSpeak.lex.c agentSpeak.l

agentSpeak.tab.c : agentSpeak.y
	bison -v -o agentSpeak.tab.c agentSpeak.y

clean-unix:
	 rm -f $(FILES_TO_DELETE)

clean-windows:
	cmd /c erase $(FILES_TO_DELETE)
