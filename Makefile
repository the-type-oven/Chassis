typing: src/chassis-typing.k
	rm -rf *kompiled
	kompile src/chassis-typing.k --backend java
	mv src/chassis-typing-kompiled .

execution: src/chassis-execution.k
	rm -rf *kompiled
	kompile src/chassis-execution.k --backend java
	mv src/chassis-execution-kompiled .

