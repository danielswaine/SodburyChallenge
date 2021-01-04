# Signs in a user to the app
def sign_in(user)
  post login_path, session: { email: user.email, password: user.password }
end
