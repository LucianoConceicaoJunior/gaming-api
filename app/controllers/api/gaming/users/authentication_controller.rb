# frozen_string_literal: true

module Api::Gaming::Users
  class AuthenticationController < ApiGuard::AuthenticationController
    before_action :find_resource, only: [ :create ]
    before_action :authenticate_resource, only: [ :destroy ]

    def create
      if resource.authenticate(@password)
        access_token, refresh_token_token = jwt_and_refresh_token(resource, resource_name)
        update_refresh_token(refresh_token: refresh_token(refresh_token_token:))
        render status: :ok, json: resource.attributes.merge(access_token:, refresh_token: refresh_token.token, password: @password, access_token_expires_at: token_expire_at, refresh_token_expires_at: refresh_token.expire_at.utc.to_i).with_indifferent_access, only: [ :id, :name, :password, :access_token, :refresh_token, :access_token_expires_at, :refresh_token_expires_at ]
      else
        render(status: :unauthorized, json: { message: Api::Constants::Messages::AUTHENTICATION_FAILED })
      end
    end

    def destroy
      blacklist_token
      render status: :ok, json: { message: Api::Constants::Messages::USER_SIGNED_OUT }
    end

    private

    def find_resource
      if params[:user_id].nil? and params[:password].nil? # should create a new user
        return render status: :forbidden, json: { message: Api::Constants::Messages::PROJECT_NOT_FOUND } unless project
        set_user(should_create: true)
        render status: :forbidden, json: { message: Api::Constants::Messages::COULD_NOT_CREATE_USER } unless resource
      else
        @password = params[:password]
        set_user
        render status: :unauthorized, json: { message: Api::Constants::Messages::AUTHENTICATION_FAILED } unless resource
      end
    end

    def create_user
      @password = SecureRandom.uuid
      user = User.new
      user.name = Faker::Name.name
      user.password = @password
      user.password_confirmation = @password
      user.organization = organization
      user.save ? user : nil
    end

    def project
      @project ||= Project.find_by(id: params[:project_id])
    end

    def organization
      @organization ||= project.organization
    end

    def set_user(should_create: false)
      if should_create
        self.resource = create_user
      else
        self.resource = User.find_by(id: params[:user_id])
      end
    end

    def refresh_token(refresh_token_token: nil)
      @refresh_token ||= RefreshToken.find_by(token: refresh_token_token)
    end

    def update_refresh_token(refresh_token:)
      refresh_token.update!(project:)
    end
  end
end
