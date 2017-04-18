zip game_0.1.1.love ./* -x .git/\*

cat ../love-builder/love.exe game_0.1.1.love > build/GameDesigner.exe
cp build/* ~/Downloads/game-designer/

mv game_0.1.1.love ../../Website/game-designer/
cd ~/Website/
echo '{version = "0.1.1"}' >game-designer/version.lua
aws s3 sync . s3://www.unashamedstudio.com --acl public-read --exclude="*.git/*"