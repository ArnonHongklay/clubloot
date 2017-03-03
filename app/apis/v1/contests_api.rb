module V1
  class ContestsAPI < Grape::API
    extend Defaults::Engine

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
              present :data, contests#, with: Entities::ProgramTemplateContestExpose
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
          if templates = Template.where(program: params[:program_id])
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
          if template = Template.find(params[:template_id])
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
