require File.dirname(__FILE__) + '/../test_helper'
require 'pages_controller'

# Re-raise errors caught by the controller.
class PagesController; def rescue_action(e) raise e end; end

class PagesControllerTest < Test::Unit::TestCase


  fixtures :pages

  def setup
    @controller = PagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    class << self
      def url_for(options, *parameters_for_method_reference)
        options.merge! :only_path => true 
        @controller.url_for(options,  *parameters_for_method_reference)
      end
    end
  end

  def test_index
    get :index
    assert_response 200
  end

  def test_show_with_valid_id
    get :show, :id => 1
    assert_response :success
  end

  def test_show_with_invalid_id
    get :show, :id => 99
    assert_response :missing
  end
  
  def test_show_should_increase_read_counter
    assert_difference 'Page.find(1).read_counter', 1 do
      get :show, :id => 1
    end
  end

  def test_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_edit_action
    get :edit, :id => 1
    assert_not_nil assigns(:page)
    assert_equal assigns(:page).class, Page
    assert_equal assigns(:page), pages(:one)
  end

  def test_edit_controller_two
    get :edit, :id => 2
    assert_equal assigns(:page), pages(:two)
  end

  def test_edit_action_invalid_id
    get :edit, :id => 99
    assert_response :missing
  end



  def test_update_action
    param = { :title => 'aus Test', :body => 'Inhalt', :category => 'main'}
    post :update, :id => 1, :page => param
    assert_response :redirect
    assert_redirected_to :action => :index
    p = Page.find 1
    param.each do |k, v|
      assert_equal v, p.send(k)
    end
  end
  
  def test_update_action_failure
    param = { :title => '', :body => 'Inhalt', :category => 'main'}
    post :update, :id => 1, :page => param
    assert_response :success
    assert_template "edit"
  end

  def test_create_action
    param = { :title => 'neu aus Test', :body => 'Inhalt', :category => 'main'}
    num_pages = Page.count
    post :create, :page => param
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_equal num_pages + 1, Page.count
    assert Page.find_by_title(param[:title])
  end
  
  def test_create_invalid_action
    param = {}
    post :create, :page => param
    assert_response :success
    assert_template 'new'
  end
  

  def test_create_action_get
    actions = [ :create, :destroy, :update ]
    actions.each do |action|
      get action
      assert_response :redirect
      assert_redirected_to :action => :index
      assert /POST/ =~ flash[:notice]
    end
  end


  def test_new_action
    get :new
    assert_response :success
    assert_template 'new'
    assert assigns(:page)
    assert_equal true, assigns(:page).new_record?
  end



  def check_page_form
    assert_select "input", :count => 3
    assert_select "input[type=text][id=page_title]"
    assert_select "input[type=text][id=page_category]"
    assert_select "textarea[id=page_body]"
    assert_select "label", :count => 3
    assert_select "label[for=page_title]", "Titel:"
    assert_select "label[for=page_category]", "Kategorie:"
    assert_select "label[for=page_body]", "Inhalt:"
  end

  def test_edit_view
    get :edit, :id => 1
    assert_select "h1", :text => 'Bearbeiten'
    assert_select "form[action='/pages/update/1']" do
      check_page_form
      assert_select "input[type=submit][value=?]", "Speichern"
    end
  end

  def test_new_view
    get :new
    assert_select "h1", :text => 'Neue Seite'
    assert_select "form[action='/pages/create']" do
      check_page_form
      assert_select "input[type=submit][value=?]", "Anlegen"
    end
  end


  def test_destroy_action
    assert Page.find(1)
    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_raise(ActiveRecord::RecordNotFound) {
      Page.find 1
    }
  end


  def test_destroy_action_get
    assert Page.find(1)
    get :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => :index
    assert Page.find(1)
  end

  def test_toggle_published
    p = Page.find 1
    assert_equal true, p.published?
    get :toggle, :id => 1
    assert_response :success
    p.reload
    assert_equal false, p.published? 
  end

  def test_create_link_in_index
    get :index
    assert_select "a[href=?]", url_for(:action => :new), :text => 'Neue Seite'
  end

  def test_edit_link_in_show
    get :show, :id => 1
    assert_select "a[href=?]", url_for(:action => :edit, :id => 1), :text => 'Bearbeiten'
  end
  
  def test_index_link_in_show
    get :show, :id => 1
    assert_select "a[href=?]", url_for(:action => :index), :text => 'Liste'
  end
  
  def test_cancel_link_in_edit
    get :edit, :id => 1
    assert_select "a[href=?]", url_for(:action => :index), :text => 'Abbrechen'
  end
end
