class UsersController < ApplicationController

    skip_before_action :authorized, only: [:create]

rescue_from ActiveRecord::RecordInvalid, with: :invalid_credentials

    def create 
        user = User.create!(user_params)
        
        token = encode_token({user_id: user.id})
        render json: {user: UserSerializer.new(user), jwt: token}, status: :created
        
    end


    def bio 
        # user = User.find_by(id: decode_token[0]['user_id'])
        render json: current_user.to_json(only: [:bio]), status: :ok
    end

    # def login 
    #     user = User.find_by(username: params[:username])
    #     if user && user.authenticate(params[:password])
    #         token = JWT.encode({"user_id": user.id}, 'mysecret')
    #         render json: {user: UserSerializer.new(user), jwt: token}, status: :ok
    #     else
    #         render json: {error: "Username or password incorrect"}, status: :unauthorized
    #     end
    # end


    private

    def user_params 
        params.permit(:username, :password, :bio)
    end

    def invalid_credentials(error)
        render json: {errors: error.record.errors.full_messages}, status: :unprocessable_entity
    end
end
