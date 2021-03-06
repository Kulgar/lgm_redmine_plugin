# Patches to the Redmine core.
Rails.configuration.to_prepare do
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Project.included_modules.include? Discuss::ProjectPatch
    Project.include(Discuss::ProjectPatch)
  end
  unless Issue.included_modules.include? Discuss::IssuePatch
    Issue.include(Discuss::IssuePatch)
  end
end

require_dependency 'discuss/hooks'

Redmine::Plugin.register :discuss do
  name 'Discuss plugin'
  author 'Régis'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :discussions do
    permission :view_discussions, discussions: [:show, :index]
    permission :add_discussion, {:discussions => [:new, :create, :edit, :update, :destroy]}, :require => :member

    permission :answer_discussions, answers: [:edit, :create, :update, :destroy]
  end

  delete_menu_item :project_menu, :boards

  menu :project_menu, :discussions, { controller: 'discussions', action: 'index' }, caption: "discussions.menu".to_sym, after: :activity, param: :project_id
end
