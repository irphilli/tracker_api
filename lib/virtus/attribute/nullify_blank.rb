# module Virtus
#   class Attribute
#
#     # Attribute extension which nullifies blank attributes when coercion failed
#     #
#     module NullifyBlank
#
#       # @see [Attribute#coerce]
#       #
#       # @api public
#       def coerce(input)
#         output = super
#
#         if !value_coerced?(output) && input.blank?
#           nil
#         # Added to nullify anything that is blank not just strings.
#         elsif output.blank?
#           nil
#         else
#           output
#         end
#       end
#
#     end # NullifyBlank
#
#   end # Attribute
# end # Virtus
