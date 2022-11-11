class ApplicationController < ActionController::API
    before_action :authorized

    @@secret_key = "#{ENV["SECRET_KEY"]}"

    def encode_token(payload) 
        JWT.encode(payload, @@secret_key)
    end

    def decode_token 
        header = request.headers['Authorization']
        if header 
            token = header.split(" ")[1]
            begin
                JWT.decode(token, @@secret_key)
            rescue JWT::DecodeError 
                nil
            end
        end
    end

    def current_user 
        if decode_token
            user_id = decode_token[0]['user_id']
            @user = User.find_by(id: user_id)
        end
    end

    def authorized
        unless !!current_user
            render json: { message: 'Please log in' }, status: :unauthorized
        end
    end


end

# fetch('url/getposts', {
#     header: {
#         Authorization: ['Bearer', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0fQ.bCK6MBgtnkQb0L5--ux3I_KuHw9URlk-8dx4nUlikRU']
#     }
# })
