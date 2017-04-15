zip -r game_0.1.0.love . -x .git/\*
mv game_0.1.0.love ../../Website/game-designer/
cd ~/Website/
aws s3 sync . s3://www.unashamedstudio.com --acl public-read --exclude="*.git/*"