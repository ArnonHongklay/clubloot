module V2
  class ContestsAPI < Grape::API

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
  end
end
