module V1
  class UsersAPI < Grape::API
    extend Defaults::Engine

    helpers do
      params :token do
        optional :token, type: String, default: nil
      end
      params :attributes do
        optional :attributes, type: Hash, default: {}
      end
    end

    resource :users do
      params do
        optional :user_id, type: String, desc: "User Id"
      end
      get '/' do
        begin
          present :status, :success
          present :data, User.all, with: Entities::UserAllExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end

    resource :user do
      resource :contests do
        params do
          requires :token, type: String, default: nil, desc: 'User Token'
          optional :state, type: String, default: "upcoming"
        end
        get "/" do
          begin
            if user = User.find_by(token: params[:token])
              contests = user.contests.find_by(state: params[:state])
              present :status, :success
              present :data, contests, with: Entities::ContestAllExpose
            else
              present :status, :failure
              present :data, "Users don't have in our system."
            end
          rescue Exception => e
            present :status, :failure
            present :data, e
          end
        end
      end

      resource :contest do
        params do
          # requires :name,    type: String, desc: "email of the user"
          # requires :program, type: String, desc: "password of the user"
          # requires :number_question,  type: Integer, desc: "email of the user"
          # requires :number, type: Integer, desc: "password of the user"
          requires :token,        type: String, default: nil, desc: 'User Token'
          requires :template_id,  type: String, desc: "Template Id"
          requires :user, type: Hash do
            optional :first_name, type: String
            optional :last_name, type: String
            # requires :address, type: Hash do
            #   requires :city, type: String
            #   optional :region, type: String
            # end
          end
        end
        post "/new" do
          begin
            template = Template.find(params[:template_id])

            if user = User.find_by(token: params[:token])
              if contest = Contest.create_contest(user, template)
                present :status, :success
                present :data, contest #, with: Entities::AuthExpose
              else
                present :status, :failure
                present :data, "Can't creating a new contest."
              end
            else
              present :status, :failure
              present :data, "Users don't have in our system."
            end
          rescue Exception => e
            present :status, :failure
            present :data, e
          end
        end

        params do
          requires :token, type: String, default: nil, desc: 'User Token'
          requires :contest_id, type: String, desc: 'contest_id'
        end
        post "/join" do
          begin
            if user = User.find_by(token: params[:token])
              if user.join_contest(params[:contest_id])
                present :status, :success
                present :data, contest #, with: Entities::AuthExpose
              else
                present :status, :failure
                present :data, "Can't join a contest."
              end
            else
              present :status, :failure
              present :data, "Users don't have in our system."
            end
          rescue Exception => e
            present :status, :failure
            present :data, e
          end
        end
      end
    end
  end
end
