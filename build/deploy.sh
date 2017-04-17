zip game_0.1.0.love ../* -x ../.git/\*
cat ../../love-builder/love.exe game_0.1.0.love > GameDesigner.exe
cp * ~/Downloads/game-designer/
zip -r game-designer.zip .
mv game-designer.zip ../game-designer.zip
mv game_0.1.0.love ../../../Website/game-designer/
cd ~/Website/
aws s3 sync . s3://www.unashamedstudio.com --acl public-read --exclude="*.git/*"