alias git-update=git-update

git-update() {
  git add .
  git commit -m "$@"
  git push
}