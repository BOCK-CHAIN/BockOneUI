$repo = "https://github.com/BOCK-CHAIN/BockOneBackend.git"

$folders = @(
"bockdocs-backend",
"bockdrive-backend",
"bockfoods-backend",
"bockmaps-backend",
"bockone-backend",
"bockvote-backend",
"eira-backend",
"golligog-backend",
"krysonix-backend",
"orventus-backend"
)

foreach ($folder in $folders) {

    Write-Host "Processing $folder..."

    cd $folder

    git init
    git remote remove origin 2>$null
    git remote add origin $repo

    git add .
    git commit -m "fresh push"

    git branch -M $folder

    git push -f origin $folder

    cd ..
}

Write-Host "All backends pushed successfully."