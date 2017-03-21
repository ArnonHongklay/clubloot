module V1
  class ContestsAPI < Grape::API
    extend Defaults::Engine

    resource :program do
      params do
        requires :program_id, type: String, desc: "Program Id"
      end
      get ':program_id' do
        begin
          programs = Program.find(params[:program_id])
          if programs
            present :status, :success
            if programs.present?
              present :data, programs
            else
              present :data, programs
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

    resource :contests do
      resource :programs do
        get '/' do
          begin
            if programs = Program.upcoming
              present :status, :success
              if programs.present?
                present :data, programs, with: Entities::ProgramsExpose
              else
                present :data, programs
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
      resource :program do
        params do
          requires :program_id, type: String, desc: "Program Id"
        end
        get ':program_id' do
          begin
            programs = Program.find(params[:program_id]).contests
            if programs
              present :status, :success
              if programs.present?
                present :data, programs, with: Entities::ProgramContestsExpose
              else
                present :data, programs
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

        params do
          requires :program_id, type: String, desc: "Program Id"
        end
        get ':program_id/all_contests' do
          begin
            programs = Program.find(params[:program_id]).all_contests
            if programs
              present :status, :success
              if programs.present?
                present :data, programs, with: Entities::ProgramTemplateContestsExpose
              else
                present :data, programs
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

        params do
          requires :program_id, type: String, desc: "Program Id"
        end
        get ':program_id/templates' do
          begin
            programs = Program.find(params[:program_id])
            if programs
              present :status, :success
              if programs.present?
                present :data, programs, with: Entities::ProgramTemplatesExpose
              else
                present :data, programs
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

        params do
          requires :program_id, type: String, desc: "Program Id"
          requires :template_id, type: String, desc: "Template Id"
        end
        get ":program_id/template/:template_id" do
          begin
            template = Program.find(params[:program_id]).templates.find(params[:template_id])
            contests = template.contests
            if contests.present?
              present :status, :success
              present :data, contests, with: Entities::ProgramTemplatesContestExpose
            else
              present :status, :failure
              present :data, "Can't show data"
            end
          rescue Exception => e
            present :status, :failure
            present :data, e
          end
        end

        params do
          requires :program_id, type: String, desc: "Program Id"
          requires :template_id, type: String, desc: "Template Id"
          requires :contest_id, type: String, desc: "Contest Id"
        end
        get ":program_id/template/:template_id/contest/:contest_id" do
          begin
            template = Program.find(params[:program_id]).templates.find(params[:template_id])
            contest = template.contests.find(params[:contest_id])
            if contest.present?
              present :status, :success
              present :data, contest, with: Entities::ProgramTemplatesContestExpose
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

      params do
        requires :program_id, type: String, desc: "Program Id"
      end
      get '/templates' do
        begin
          if templates = Template.active.where(program: params[:program_id])
            present :status, :success
          else
            present :status, :failure
          end
          present :data, templates, with: Entities::TemplatesExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end

      params do
        requires :template_id, type: String, desc: "Template Id"
      end
      get "/template" do
        begin
          if template = Template.active.find(params[:template_id])
            present :status, :success
          else
            present :status, :failure
          end
          present :data, template, with: Entities::TemplateExpose
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end

      params do
        requires :player, type: Integer, desc: "number of player"
      end
      get '/player' do
        begin
          fee = nil
          Contest.gem_matrix[:list].each{ |x| fee = x[:fee] if x[:player] == params[:player] }

          if fee.present?
            present :status, :success
          else
            present :status, :failure
          end
          present :data, fee
        rescue Exception => e
          present :status, :failure
          present :data, e
        end
      end
    end
  end
end
