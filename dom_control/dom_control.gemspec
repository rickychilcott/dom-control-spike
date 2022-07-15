Gem::Specification.new do |s|
  s.name        = "dom_control"
  s.version     = "0.0.0"
  s.summary     = "DOMControl"
  s.description = "A simple hello world gem"
  s.authors     = ["Ricky Chilcott", "Phil Monroe"]
  s.email       = "ricky@missionmet.com"
  s.files =     ["dom_control.gemspec"] + `git ls-files | grep -E '^dom_control/(bin|lib)'`.split("\n")

  s.homepage    =
    "https://rubygems.org/gems/dom_control"
  s.license       = "MIT"
end
