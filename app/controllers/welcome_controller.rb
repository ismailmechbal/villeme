# encoding: utf-8

class WelcomeController < ApplicationController

	include InviteModule

	layout 'welcome'

	def index

		if user_signed_in? && current_user.invited
			redirect_to root_path and return
		end

		if params[:key]
			create_user_from_invite(params[:key])
  		@invite = Invite.new
		else
  		@invite = Invite.new
  	end

    @cities = City.limit(5).order(:goal)

    @invites = Invite.all

  end




end
