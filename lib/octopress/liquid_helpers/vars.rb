module Octopress
  module VarHelpers
    VAR_SYNTAX = /(#{Liquid::VariableSignature}+)\s*(=|\+=)\s*(.*)\s*/o

    def determine_value(vars, context)
      vars.each do |var|
        rendered = var.render(context)
        return rendered unless rendered.nil?
      end
      nil
    end

    def get_value(vars, context)
      vars = vars.strip.split("||").map do |v|
        Liquid::Variable.new(v.strip)
      end
      value = determine_value(vars, context)
      if value.nil?
        var = vars.last.name
        if var == 'nil'
          nil
        else
          vars.last.name.gsub /^['"]?((?:.)+?)["']?$/, '\1'
        end
      else
        value
      end
    end
  end
end
