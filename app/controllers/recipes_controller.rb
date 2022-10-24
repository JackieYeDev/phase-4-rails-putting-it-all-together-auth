class RecipesController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    def index
        user = User.find_by(id: session[:user_id])
        if user
            recipes = Recipe.all
            render json: recipes, include: ['user']
        else
            render json: { errors: ["Unauthorized"] }, status: :unauthorized
        end
    end
    def show
        user = User.find_by(id: session[:user_id])
        if user
            recipes = user.recipes
            render json: recipes
        else
            render json: { error: "Unauthorized" }, status: :unauthorized
        end
    end
    
    def create
        user = User.find_by(id: session[:user_id])
        if user
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, status: :created
        else
            render json: { errors: ["Unauthorized"]}, status: :unauthorized
        end
    end

    private
    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
end
