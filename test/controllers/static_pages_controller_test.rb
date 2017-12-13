require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get static_pages_home_url
    assert_response :success
  end

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", I18n.t("application.title")
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", I18n.t("static_pages.about.title") + " | " + I18n.t("application.title")
  end

  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
    assert_select "title", I18n.t("static_pages.contact.title") + " | " + I18n.t("application.title")
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", I18n.t("static_pages.help.title") + " | " + I18n.t("application.title")
  end
end
sdfj
