nothing:
	echo "Please specify either 'build', 'tar' or 'tar build'"

tar:
	cd aws-scripts_ && \
	tar cvzf ../aws-scripts.tar.gz . && \
	cd ..

build:
	cp installer_src.sh installer.sh
	cat aws-scripts.tar.gz >> installer.sh
	chmod +x installer.sh

.PHONEY: nothing