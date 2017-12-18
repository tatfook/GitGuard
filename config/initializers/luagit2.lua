
NPL.load("../../lib/luagit2/init")
print(os.getenv("HOME"))
GIT.root_path = os.getenv("HOME") .. "/repositories/"
