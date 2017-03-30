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
      resource :profile do
        params do
          requires :token, type: String, default: nil, desc: 'User Token'
        end
        get "/" do
          begin
            if user = User.find_by(token: params[:token])
              present :status, :success
              present :data, user, with: Entities::UserAllExpose
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

      resource :contests do
        params do
          requires :token, type: String, default: nil, desc: 'User Token'
          optional :state, type: String, default: "upcoming", desc: 'all, upcoming, live, past, winners'
        end
        get "/" do
          begin
            if user = User.find_by(token: params[:token])
              if params[:state].eql?('winners')
                contests = user.winners.order(updated_at: :desc)
              elsif params[:state].eql?('past')
                contests = user.contests.where(_state: { '$in': [:end, :cancel]}).order(updated_at: :desc)
              elsif params[:state].eql?('all')
                contests = user.contests.order(updated_at: :desc)
              else
                contests = user.contests.where(_state: params[:state]).order(updated_at: :desc)
              end
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
          requires :token,      type: String, default: nil, desc: 'User Token'
        end
        get ":contest_id" do
          begin
            if user = User.find_by(token: params[:token])
              if contest = user.contests.find(params[:contest_id])
                present :status, :success
                present :data, contest, with: Entities::ContestAllExpose
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
          requires :token,        type: String, default: nil, desc: 'User Token'
          requires :template_id,  type: String, desc: "Template Id"
          requires :details, type: Hash do
            requires :name, type: String
            requires :player, type: Integer
            requires :fee, type: Integer
          end
        end
        post "/new" do
          begin
            template = Template.find(params[:template_id])

            if user = User.find_by(token: params[:token])
              if contest = Contest.create_contest(user, template, params[:details])
                present :status, :success
                present :data, contest, with: Entities::ContestExpose
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
              if contest = Contest.join_contest(user, params[:contest_id])
                present :status, :success
                present :data, contest, with: Entities::ContestExpose
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

        params do
          requires :token, type: String, default: nil, desc: 'User Token'
          requires :contest_id, type: String, desc: 'contest_id'
        end
        post "/edit" do
          begin
            if user = User.find_by(token: params[:token])
              if contest = Contest.edit_contest(user, params[:contest_id])
                present :status, :success
                present :data, contest, with: Entities::ContestEditExpose
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

        params do
          requires :token,        type: String, default: 'EJGB2R9ETPHNJSHGDYSJ283KTXCBSR6X', desc: 'User Token'
          requires :contest_id,   type: String, default: '58b82e942cc3c43e4e31ca2c', desc: "Contest Id"
          requires :details,      type: Array[JSON], default: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]', desc: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]'
        end
        post "/quiz" do
          begin
            if user = User.find_by(token: params[:token])
              if contest = user.contests.find(params[:contest_id])
                if quiz_contest = Contest.quiz(user, contest, params[:details])
                  present :status, :success
                  present :data, quiz_contest #, with: Entities::AuthExpose
                else
                  present :status, :failure
                  present :data, "Can't complete quiz"
                end
              else
                present :status, :failure
                present :data, "Can't found contest"
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
          requires :token,        type: String, default: 'EJGB2R9ETPHNJSHGDYSJ283KTXCBSR6X', desc: 'User Token'
          requires :contest_id,   type: String, default: '58b82e942cc3c43e4e31ca2c', desc: "Contest Id"
          requires :details,      type: Array[JSON], default: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]', desc: '[{"question_id": "58b06a592cc3c47a89de1a28", "answer_id": "58b06a592cc3c47a89de1a29"}, {"question_id": "58b06a592cc3c47a89de1a2b", "answer_id": "58b06a592cc3c47a89de1a2d"}]'
        end
        post "/edit_quiz" do
          begin
            if user = User.find_by(token: params[:token])
              if contest = user.contests.find(params[:contest_id])
                if quiz_contest = Contest.edit_quiz(user, contest, params[:details])
                  present :status, :success
                  present :data, quiz_contest #, with: Entities::AuthExpose
                else
                  present :status, :failure
                  present :data, "Can't complete quiz"
                end
              else
                present :status, :failure
                present :data, "Can't found contest"
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

      resource :prize do
        params do
          requires :token,    type: String, default: 'EJGB2R9ETPHNJSHGDYSJ283KTXCBSR6X', desc: 'User Token'
          requires :prize_id, type: String, desc: "Prize Id"
        end
        post '/' do
          begin
            prizes = User.find_by(token: params[:token]).get_prizes(params[:prize_id])
            if prizes
              present :status, :success
              if prizes.present?
                present :data, prizes
              else
                present :data, prizes
              end
            else
              present :status, :failure
              present :data, "Can't show data"
            end
          rescue Exception => e
            present :status, :failure
            present :data, e
          end
        end
      end

      resource :convert_gem do
        params do
          requires :token,    type: String, default: 'EJGB2R9ETPHNJSHGDYSJ283KTXCBSR6X', desc: 'User Token'
          requires :type,     type: String, default: 'ruby', desc: "Contest Id"
        end
        post ':program_id' do
          begin
            # prize = Prize.find(params[:prize_id])
            # if prize
              present :status, :success
            #   if prize.present?
            #     present :data, programs
            #   else
            #     present :data, programs
            #   end
            # else
            #   present :status, :failure
            #   present :data, "Can't show data"
            # end
          rescue Exception => e
            present :status, :failure
            present :data, e
          end
        end
      end

    end
  end
end
