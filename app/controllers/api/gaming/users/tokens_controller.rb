# frozen_string_literal: true

module Api::Gaming::Users
  class TokensController < ApiGuard::TokensController
    before_action :authenticate_resource, only: [ :create ]
    before_action :find_refresh_token, only: [ :create ]

    def create
      resource = current_user
      access_token, refresh_token_token = jwt_and_refresh_token(resource, resource_name)
      @old_refresh_token.destroy

      update_refresh_token(refresh_token: refresh_token(refresh_token_token:))
      blacklist_token if ApiGuard.blacklist_token_after_refreshing

      render status: :ok, json: { access_token:, refresh_token: refresh_token.token, access_token_expires_at: token_expire_at, refresh_token_expires_at: refresh_token.expire_at.to_i }
    end

    private

    def find_refresh_token
      refresh_token = params[:refresh_token]

      if refresh_token
        @old_refresh_token = find_refresh_token_of(current_resource, refresh_token)
        if @old_refresh_token
          @project = @old_refresh_token.project
        else
          render status: :unauthorized, json: { message: 'Invalid refresh token' }
        end
      else
        render status: :unauthorized, json: { message: 'Missing refresh token' }
      end
    end

    def project
      @project ||= Project.find_by(id: params[:project_id])
    end

    def refresh_token(refresh_token_token: nil)
      @refresh_token ||= RefreshToken.find_by(token: refresh_token_token)
    end

    def update_refresh_token(refresh_token:)
      refresh_token.update!(project:)
    end
  end
end
