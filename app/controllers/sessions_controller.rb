class SessionsController < ApplicationController
    def create
       user = User.find_by(username: params[:username])
       if user&.authenticate(params[:password]) 
            session[:user_id] = user.id
            render json: user, status: :created
       else
            render json: { errors: ["Invalid username or password"] }, status: :unauthorized
       end
    end

    def destroy
        if session[:user_id] != nil
            session.delete :user_id
            head :no_content
        else
            render json: { errors: ["Unauthorized"] }, status: :unauthorized
        end
    end

    private
    def render_unauthorized_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unauthorized
    end
end
