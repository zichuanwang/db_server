require "rubypython"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  RubyPython.start(:python_exe => "python2.7") # start the Python interpreter
end
