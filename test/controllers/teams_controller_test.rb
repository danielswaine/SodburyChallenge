require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  setup do
    @team = teams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create team" do
    assert_difference('Team.count') do
      post :create, team: { due_end_time: @team.due_end_time, due_phone_in_time: @team.due_phone_in_time, end_time: @team.end_time, name: @team.name, phone_in_time: @team.phone_in_time, route_id: @team.route_id, score: @team.score, start_time: @team.start_time, team_number: @team.team_number, team_year: @team.team_year }
    end

    assert_redirected_to team_path(assigns(:team))
  end

  test "should show team" do
    get :show, id: @team
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @team
    assert_response :success
  end

  test "should update team" do
    patch :update, id: @team, team: { due_end_time: @team.due_end_time, due_phone_in_time: @team.due_phone_in_time, end_time: @team.end_time, name: @team.name, phone_in_time: @team.phone_in_time, route_id: @team.route_id, score: @team.score, start_time: @team.start_time, team_number: @team.team_number, team_year: @team.team_year }
    assert_redirected_to team_path(assigns(:team))
  end

  test "should destroy team" do
    assert_difference('Team.count', -1) do
      delete :destroy, id: @team
    end

    assert_redirected_to teams_path
  end
end
