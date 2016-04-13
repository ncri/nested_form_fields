require 'spec_helper'

describe 'a form with nested projects with nested todos', :js => true do

  it 'creates a user with nested projects with nested todos' do
    visit '/'

    fill_in 'user_name', with: 'user name'

    click_link 'Add Project'
    page.should have_css('fieldset.nested_user_projects')
    fill_in 'user_projects_attributes_0_name', with: 'p1 name'
    fill_in 'user_projects_attributes_0_description', with: 'p1 description'

    click_link 'Add Todo'
    page.should have_css('fieldset.nested_user_projects_0_todos')
    fill_in 'user_projects_attributes_0_todos_attributes_0_description', with: 'todo text'

    click_link 'Add Project'
    fill_in 'user_projects_attributes_1_name', with: 'p2 name'
    fill_in 'user_projects_attributes_1_description', with: 'p2 description'

    assert_difference 'User.count', +1 do
      click_on 'Create User'
    end

    user = User.last
    projects = user.projects
    todos = projects.first.todos
    projects.count.should == 2
    todos.count.should == 1
    user.name.should == 'user name'
    projects[0].name.should == 'p1 name'
    projects[0].description.should == 'p1 description'
    projects[1].name.should == 'p2 name'
    projects[1].description.should == 'p2 description'
    todos[0].description.should == 'todo text'
  end

  let(:user) do
    user = User.create(name: 'user name')
    user.projects.create(name: 'p1 name', description: 'p1 description')
    user.projects.create(name: 'p2 name', description: 'p2 description')
    user.projects.first.todos.create(description: 'todo text')
    user
  end

  it 'edits a user with nested projects with nested todos' do
    Capybara.ignore_hidden_elements = true

    visit edit_user_path(user)

    page.should have_css('fieldset.nested_user_projects_0_todos')
    page.find('.nested_user_projects_0_todos .remove_nested_fields_link.test_class').click
    page.should_not have_css('fieldset.nested_user_projects_0_todos')

    page.all('.nested_user_projects .remove_nested_fields_link').count.should == 2
    page.all('.nested_user_projects .remove_nested_fields_link').last.click
    page.all('.nested_user_projects .remove_nested_fields_link').count.should == 1

    fill_in 'user_projects_attributes_0_name', with: 'new name'

    click_link 'Add Todo'
    page.should have_css('fieldset.nested_user_projects_0_todos')

    fill_in 'user_projects_attributes_0_todos_attributes_1_description', with: 'new text'

    click_on 'Update User'

    projects = user.projects
    todos = projects.first.todos
    projects.count.should == 1
    todos.count.should == 1
    projects[0].name.should == 'new name'
    todos[0].description.should == 'new text'

    Capybara.ignore_hidden_elements = false
  end


end