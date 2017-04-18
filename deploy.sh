zip game_0.1.8.love ./* assets/* sti/* -x .git/\*

cat ../love-builder/love.exe game_0.1.8.love > build/GameDesigner.exe
cp build/* ~/Downloads/game-designer/

mv game_0.1.8.love ../../Website/game-designer/
cd ~/Website/
echo '{version = "0.1.8"}' >game-designer/version.lua
aws s3 sync . s3://www.unashamedstudio.com --acl public-read --exclude="*.git/*"