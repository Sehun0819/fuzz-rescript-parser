SHELL = /bin/bash

parser:
	cd syntax
	make

corpus:
	mkdir rs_files
	find rescript_projs -type f \( -name "*.res" -o -name "*.resi" \) | xargs cp -t rs_files/
	afl-cmin -i ~/rs_files -o ~/rs_files_unique -- ~/syntax/_build/default/cli/res_cli.exe  @@

fuzz: parser corpus
	afl-fuzz -i ~/rs_files_unique -o ~/fuzz_report -- ~/syntax/_build/default/cli/res_cli.exe  @@

cleanparser:
	cd syntax
	make clean

cleancorpus:
	rm -rf rs_files
	rm -rf rs_files_unique

clean:
	make cleanparser
	make cleancorpus