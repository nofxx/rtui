# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rtui}
  s.version = "0.1.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcos Piccinini"]
  s.date = %q{2008-12-21}
  s.description = %q{Set of tools for TUI Eye Candy}
  s.email = ["x@nofxx.com"]
  s.extra_rdoc_files = ["History.txt", "LICENSE.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "LICENSE.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/rtui.rb", "lib/rtui/progress.rb", "rspec.rake", "rtui.gemspec", "script/console", "script/destroy", "script/generate", "spec/rtui/progress_spec.rb", "spec/rtui_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/nofxx/rtui}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rtui}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby TUI Helpers}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.2.1"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.2.1"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.2.1"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
