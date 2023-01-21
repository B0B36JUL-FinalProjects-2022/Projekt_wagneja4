using Documenter, BBforILP
using DocumenterMarkdown
using JuMP

repo_url = "https://github.com/B0B36JUL-FinalProjects-2022/Projekt_wagneja4.git"
site_name = "BBforILP"
# make html page
makedocs(
    modules = [BBforILP],
    sitename = site_name,
    build = "build/html",
    repo = repo_url,
    strict = false
)
# make wiki md page
makedocs(
    modules = [BBforILP],
    sitename = site_name,
    format = Markdown(),
    build = "build/md/wiki",
    repo = repo_url,
    strict = false
)

# make readme md page
makedocs(
    modules = [BBforILP],
    sitename = site_name,
    format = Markdown(),
    build = "build/md/readme",
    repo = repo_url,
    strict = false,
    source = "readme"
)
