module Documents
  module ResumeGenerationService
    def self.generate_from_command(message:)
      WickedPdf.new.pdf_from_string("<h1>Hello #{message.data.first_name}  #{message.data.last_name}</h1>")
    end
  end
end
