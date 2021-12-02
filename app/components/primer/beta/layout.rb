# frozen_string_literal: true

module Primer
  module Beta
    # `Layout` provides foundational patterns for responsive pages.
    # `Layout` can be used for simple two-column pages, or it can be nested to provide flexible 3-column experiences.
    #  On smaller screens, `Layout` uses vertically stacked rows to display content.
    #
    # `Layout` flows as both column, when there's enough horizontal space to render both `Main` and `Pane`side-by-side (on a desktop of tablet device, per instance);
    # or it flows as a row, when `Main` and `Pane` are stacked vertically (e.g. on a mobile device).
    # `Layout` should always work in any screen size.
    #
    # `Layout` also provides `Header` and `Footer` slots, which can be used to provide a consistent header and footer across all pages.
    #
    # @accessibility
    #   Keyboard navigation follows the markup order. Decide carefully how the focus order should be be by deciding whether
    #   `main` or `pane` comes first in code. The code order won’t affect the visual position.
    class Layout < Primer::Component
      WRAPPER_SIZING_DEFAULT = :fluid
      WRAPPER_SIZING_OPTIONS = [WRAPPER_SIZING_DEFAULT, :md, :lg, :xl].freeze

      OUTER_SPACING_DEFAULT = :none
      OUTER_SPACING_MAPPINGS = {
        OUTER_SPACING_DEFAULT => "",
        :normal => "LayoutBeta--outer-spacing-normal",
        :condensed => "LayoutBeta--outer-spacing-condensed"
      }.freeze
      OUTER_SPACING_OPTIONS = OUTER_SPACING_MAPPINGS.keys.freeze

      INNER_SPACING_DEFAULT = :none
      INNER_SPACING_MAPPINGS = {
        INNER_SPACING_DEFAULT => "",
        :normal => "LayoutBeta--inner-spacing-normal",
        :condensed => "LayoutBeta--inner-spacing-condensed"
      }.freeze
      INNER_SPACING_OPTIONS = INNER_SPACING_MAPPINGS.keys.freeze

      COLUMN_GAP_DEFAULT = :none
      COLUMN_GAP_MAPPINGS = {
        COLUMN_GAP_DEFAULT => "",
        :normal => "LayoutBeta--column-gap-normal",
        :condensed => "LayoutBeta--column-gap-condensed"
      }.freeze
      COLUMN_GAP_OPTIONS = COLUMN_GAP_MAPPINGS.keys.freeze

      ROW_GAP_DEFAULT = :none
      ROW_GAP_MAPPINGS = {
        ROW_GAP_DEFAULT => "",
        :normal => "LayoutBeta--row-gap-normal",
        :condensed => "LayoutBeta--row-gap-condensed"
      }.freeze
      ROW_GAP_OPTIONS = ROW_GAP_MAPPINGS.keys.freeze

      RESPONSIVE_BEHAVIOR_DEFAULT = :flow_vertical
      RESPONSIVE_BEHAVIOR_MAPPINGS = {
        RESPONSIVE_BEHAVIOR_DEFAULT => "LayoutBeta--responsive-flowVertical",
        :split_as_pages => "LayoutBeta--responsive-splitAsPages"
      }.freeze
      RESPONSIVE_BEHAVIOR_OPTIONS = RESPONSIVE_BEHAVIOR_MAPPINGS.keys.freeze

      PANE_WIDTH_DEFAULT = :default
      PANE_WIDTH_MAPPINGS = {
        PANE_WIDTH_DEFAULT => "",
        :narrow => "LayoutBeta--pane-width-narrow",
        :wide => "LayoutBeta--pane-width-wide"
      }.freeze
      PANE_WIDTH_OPTIONS = PANE_WIDTH_MAPPINGS.keys.freeze

      PANE_POSITION_DEFAULT = :start
      PANE_POSITION_MAPPINGS = {
        PANE_POSITION_DEFAULT => "LayoutBeta--pane-position-start",
        :end => "LayoutBeta--pane-position-end"
      }.freeze
      PANE_POSITION_OPTIONS = PANE_POSITION_MAPPINGS.keys.freeze

      PANE_RESPONSIVE_POSITION_DEFAULT = :inherit
      PANE_RESPONSIVE_POSITION_MAPPINGS = {
        PANE_RESPONSIVE_POSITION_DEFAULT => "",
        :start => "LayoutBeta--pane-responsive-position-start",
        :end => "LayoutBeta--pane-responsive-position-end"
      }.freeze
      PANE_RESPONSIVE_POSITION_OPTIONS = PANE_RESPONSIVE_POSITION_MAPPINGS.keys.freeze

      PANE_DIVIDER_DEFAULT = :start
      PANE_DIVIDER_MAPPINGS = {
        PANE_DIVIDER_DEFAULT => "LayoutBeta--pane-position-start",
        :end => "LayoutBeta--pane-position-start"
      }.freeze
      PANE_DIVIDER_OPTIONS = PANE_DIVIDER_MAPPINGS.keys.freeze

      # The layout's main content.
      #
      # @param width [Symbol] <%= one_of(Primer::Beta::Layout::Main::WIDTH_OPTIONS) %>
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      renders_one :main, "Primer::Beta::Layout::Main"

      # The layout's sidebar.
      #
      # @param width [Symbol] <%= one_of(Primer::Beta::Layout::PANE_WIDTH_OPTIONS) %>
      # @param position [Symbol] Pane placement when `Layout` is in column modes. <%= one_of(Primer::Beta::Layout::PANE_POSITION_OPTIONS) %>
      # @param responsive_position [Symbol] Pane placement when `Layout` is in column modes. <%= one_of(Primer::Beta::Layout::PANE_RESPONSIVE_POSITION_OPTIONS) %>
      # @param divider [Boolean] Whether to show a pane line divider.
      # @param sticky [Boolean] Whether to make the pane sticky. Don’t use it in the presence of footer regions.
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      renders_one :pane, lambda { |
        width: PANE_WIDTH_DEFAULT,
        position: PANE_POSITION_DEFAULT,
        responsive_position: PANE_RESPONSIVE_POSITION_DEFAULT,
        sticky: false,
        divider: false,
        **system_arguments
      |
        responsive_position = position if responsive_position == :inherit

        # These classes have to be set in the parent `Layout` element, so we modify its system arguments.
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          PANE_POSITION_MAPPINGS[fetch_or_fallback(PANE_POSITION_OPTIONS, position, PANE_POSITION_DEFAULT)],
          PANE_RESPONSIVE_POSITION_MAPPINGS[fetch_or_fallback(PANE_RESPONSIVE_POSITION_OPTIONS, responsive_position, PANE_RESPONSIVE_POSITION_DEFAULT)],
          PANE_WIDTH_MAPPINGS[fetch_or_fallback(PANE_WIDTH_OPTIONS, width, PANE_WIDTH_DEFAULT)],
          { "LayoutBeta--pane-divider" => divider },
          { "LayoutBeta--pane-is-sticky" => sticky }
        )

        Primer::Beta::Layout::Pane.new(**system_arguments)
      }

      # The layout's header.
      #
      # @param divider [Boolean] Whether to show a header divider
      # @param responsive_divider [Boolean] Whether to show a divider below the `header` region if in responsive mode
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      renders_one :header, lambda { |divider: false, **header_system_arguments|
        # These classes have to be set in the parent `Layout` element, so we modify its system arguments.
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "LayoutBeta--has-header",
          "LayoutBeta--header-divider" => divider
        )

        header_system_arguments[:classes] = class_names(
          header_system_arguments[:classes],
          "LayoutBeta-header"
        )

        Primer::Beta::Layout::Bookend.new(divider: divider, **header_system_arguments)
      }

      # The layout's footer.
      #
      # @param divider [Boolean] Whether to show a footer divider
      # @param responsive_divider [Boolean] Whether to show a divider below the `footer` region if in responsive mode
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      renders_one :footer, lambda { |divider: false, **footer_system_arguments|
        # These classes have to be set in the parent `Layout` element, so we modify its system arguments.
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "LayoutBeta--has-footer",
          "LayoutBeta--footer-divider" => divider
        )

        footer_system_arguments[:classes] = class_names(
          footer_system_arguments[:classes],
          "LayoutBeta-footer"
        )

        Primer::Beta::Layout::Bookend.new(divider: divider, **footer_system_arguments)
      }

      # @example Default
      #
      #   <%= render(Primer::Beta::Layout.new) do |c| %>
      #     <% c.main(border: true) { "Main" } %>
      #     <% c.pane(border: true) { "Pane" } %>
      #   <% end %>
      #
      # @example Header and footer
      #
      #   <%= render(Primer::Beta::Layout.new) do |c| %>
      #     <% c.header(border: true) { "Header" } %>
      #     <% c.main(border: true) { "Main" } %>
      #     <% c.pane(border: true) { "Pane" } %>
      #     <% c.footer(border: true) { "Footer" } %>
      #   <% end %>
      #
      # @example Wrapper sizing
      #
      #   @description
      #     When `:fluid` the layout will be set to full width. When the other sizing options are used the layout will be centered with corresponding widths.
      #
      #     - `:fluid`: full width
      #     - `:md`: max-width: 768px
      #     - `:lg`: max-width: 1012px
      #     - `:xl`: max-width: 1280px
      #
      #   @code
      #     <%= render(Primer::Beta::Layout.new(wrapper_sizing: :fluid)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(wrapper_sizing: :md)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(wrapper_sizing: :lg)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(wrapper_sizing: :xl)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #
      # @example Outer spacing
      #
      #   @description
      #     Sets wrapper margins surrounding the component to distance itself from the viewport edges.
      #
      #     - `:none`` sets the margin to 0.
      #     - `:condensed` keeps the margin at 16px.
      #     - `:normal`` sets the margin to 16px, and to 24px on lg breakpoints and above.
      #
      #   @code
      #     <%= render(Primer::Beta::Layout.new(outer_spacing: :none)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(outer_spacing: :condensed)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(outer_spacing: :normal)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #
      # @example Inner spacing
      #
      #   @description
      #     Sets padding to regions individually.
      #
      #     - `:none` sets the padding to 0.
      #     - `:condensed`` keeps the padding always at 16px.
      #     - `:normal` sets padding to 16px, with the content region getting 24px horizontal padding on lg breakpoints and above.
      #
      #   @code
      #     <%= render(Primer::Beta::Layout.new(inner_spacing: :none)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(inner_spacing: :condensed)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(inner_spacing: :normal)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #
      # @example Column gap
      #
      #   @description
      #     Sets the gap between columns to distance them from each other.
      #
      #     - `:none` sets the gap to 0.
      #     - `:condensed` keeps the gap always at 16px.
      #     - `:normal` sets the gap to 16px, and to 24px on lg breakpoints and above.
      #
      #   @code
      #     <%= render(Primer::Beta::Layout.new(column_gap: :none)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(column_gap: :condensed)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(column_gap: :normal)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #
      # @example Row gap
      #
      #   @description
      #     Sets the gap below the header and above the footer.
      #
      #     - `:none` sets the gap to 0.
      #     - `:condensed` keeps the gap always at 16px.
      #     - `:normal` sets the gap to 16px, and to 24px on lg breakpoints and above.
      #
      #   @code
      #     <%= render(Primer::Beta::Layout.new(row_gap: :none)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(row_gap: :condensed)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(row_gap: :normal)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #
      # @example Pane widths
      #
      #   @description
      #     Sets the pane width. The width is predetermined according to the breakpoint instead of it being percentage-based.
      #
      #     - `default`:
      #     - `narrow`:
      #     - `wide`:
      #
      #     When flowing as a row, `Pane` takes the full width.
      #
      #   @code
      #     <%= render(Primer::Beta::Layout.new) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(width: :default, border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(mt: 5)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(width: :narrow, border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(mt: 5)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(width: :wide, border: true) { "Pane" } %>
      #     <% end %>
      #
      # @example Pane position
      #
      #   @description
      #     Use `start` for sidebars that manipulate local navigation, while right-aligned `end` is useful for metadata and other auxiliary information.
      #
      #   @code
      #     <%= render(Primer::Beta::Layout.new) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(position: :start, border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new( mt: 5)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(position: :end, border: true) { "Pane" } %>
      #     <% end %>
      #
      # @example Pane resposive position
      #
      #   @description
      #     Defines the position of the pane in the responsive layout.
      #
      #     - `:start` puts the pane above content
      #     - `:end` puts it below content.
      #     - `:inherit` uses the same value from `pane_position`
      #
      #   @code
      #     <%= render(Primer::Beta::Layout.new(mt: 5)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(pane_responsive_position: :inherit, border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(pane_responsive_position: :start, border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new(mt: 5)) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(pane_responsive_position: :end, border: true) { "Pane" } %>
      #     <% end %>
      #
      # @example Header
      #
      #   @description
      #     You can add an optional header to the layout and have spacing and positioning taken care of for you.
      #     You can optionally add a divider to the header.
      #
      #   @code
      #     <%= render(Primer::Beta::Layout.new) do |c| %>
      #       <% c.header(border: true) { "Header" } %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new) do |c| %>
      #       <% c.header(divider: true, border: true) { "Header" } %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #     <% end %>
      #
      # @example Footer
      #
      #   @description
      #     You can add an optional footer to the layout and have spacing and positioning taken care of for you.
      #     You can optionally add a divider to the footer.
      #
      #   @code
      #     <%= render(Primer::Beta::Layout.new) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #       <% c.footer(border: true) { "Header" } %>
      #     <% end %>
      #     <%= render(Primer::Beta::Layout.new) do |c| %>
      #       <% c.main(border: true) { "Main" } %>
      #       <% c.pane(border: true) { "Pane" } %>
      #       <% c.footer(divider: true, border: true) { "Header" } %>
      #     <% end %>
      #
      # @param wrapper_sizing [Symbol] The size of the container wrapping `Layout`. <%= one_of(Primer::Beta::Layout::WRAPPER_SIZING_OPTIONS) %>
      # @param outer_spacing [Symbol] Sets wrapper margins surrounding the component to distance itself from the viewport edges. <%= one_of(Primer::Beta::Layout::OUTER_SPACING_OPTIONS) %>
      # @param inner_spacing [Symbol] Sets padding to regions individually. <%= one_of(Primer::Beta::Layout::INNER_SPACING_OPTIONS) %>
      # @param column_gap [Symbol] Sets gap between columns. <%= one_of(Primer::Beta::Layout::COLUMN_GAP_OPTIONS) %>
      # @param row_gap [Symbol] Sets the gap below the header and above the footer. <%= one_of(Primer::Beta::Layout::ROW_GAP_OPTIONS) %>
      # @param responsive_behavior [Symbol] `responsive_behavior` defines how the layout component adapts to smaller viewports. `:flow_vertical` presents the content in a vertical flow, with pane and content vertically arranged. `:split_as_pages` presents pane and content as different pages on smaller viewports. <%= one_of(Primer::Beta::Layout::RESPONSIVE_BEHAVIOR_OPTIONS) %>
      # @param responsive_show_pane_first [Boolean] Defines if the pane should be shown first in the responsive layout. If `responsive_behavior` is set to `:flow_vertical`, pane appears above content. If set to `split_as_pages`, pane will appear as a landing page. Use only in the first page of the section.
      # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
      def initialize(
        wrapper_sizing: WRAPPER_SIZING_DEFAULT,
        outer_spacing: OUTER_SPACING_DEFAULT,
        inner_spacing: INNER_SPACING_DEFAULT,
        column_gap: COLUMN_GAP_DEFAULT,
        row_gap: ROW_GAP_DEFAULT,
        responsive_behavior: RESPONSIVE_BEHAVIOR_DEFAULT,
        responsive_show_pane_first: false,
        **system_arguments
      )
        @wrapper_sizing = fetch_or_fallback(WRAPPER_SIZING_OPTIONS, wrapper_sizing, WRAPPER_SIZING_DEFAULT)

        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @system_arguments[:classes] = class_names(
          "LayoutBeta",
          OUTER_SPACING_MAPPINGS[fetch_or_fallback(OUTER_SPACING_OPTIONS, outer_spacing, OUTER_SPACING_DEFAULT)],
          INNER_SPACING_MAPPINGS[fetch_or_fallback(INNER_SPACING_OPTIONS, inner_spacing, INNER_SPACING_DEFAULT)],
          COLUMN_GAP_MAPPINGS[fetch_or_fallback(COLUMN_GAP_OPTIONS, column_gap, COLUMN_GAP_DEFAULT)],
          ROW_GAP_MAPPINGS[fetch_or_fallback(ROW_GAP_OPTIONS, row_gap, ROW_GAP_DEFAULT)],
          RESPONSIVE_BEHAVIOR_MAPPINGS[fetch_or_fallback(RESPONSIVE_BEHAVIOR_OPTIONS, responsive_behavior, RESPONSIVE_BEHAVIOR_DEFAULT)],
          { "LayoutBeta--responsive-pane-first" => responsive_show_pane_first },
          system_arguments[:classes]
        )
      end

      def render?
        main.present? && pane.present?
      end

      # The layout's main content.
      class Main < Primer::Component
        WIDTH_DEFAULT = :full
        WIDTH_OPTIONS = [WIDTH_DEFAULT, :md, :lg, :xl].freeze

        TAG_DEFAULT = :div
        TAG_OPTIONS = [TAG_DEFAULT, :main].freeze

        # @param width [Symbol] <%= one_of(Primer::Beta::Layout::Main::WIDTH_OPTIONS) %>
        # @param tag [Symbol] <%= one_of(Primer::Beta::Layout::Main::TAG_OPTIONS) %>
        # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
        def initialize(tag: TAG_DEFAULT, width: WIDTH_DEFAULT, **system_arguments)
          @width = fetch_or_fallback(WIDTH_OPTIONS, width, WIDTH_DEFAULT)

          @system_arguments = system_arguments
          @system_arguments[:tag] = fetch_or_fallback(TAG_OPTIONS, tag, TAG_DEFAULT)
          @system_arguments[:classes] = class_names(
            "LayoutBeta-content",
            system_arguments[:classes]
          )
        end

        def call
          render(Primer::BaseComponent.new(**@system_arguments)) do
            if @width == :full
              content
            else
              render(Primer::BaseComponent.new(tag: :div, classes: "Layout-main-centered-#{@width}")) do
                render(Primer::BaseComponent.new(tag: :div, container: @width)) do
                  content
                end
              end
            end
          end
        end
      end

      # The layout's header or footer content. This componentn is used by the `header` and `footer` slots and configured via those slots.
      class Bookend < Primer::Component
        RESPONSIVE_DIVIDER_DEFAULT = :none
        RESPONSIVE_DIVIDER_MAPPINGS = {
          RESPONSIVE_DIVIDER_DEFAULT => "",
          :line => "LayoutBeta-region--line-divider",
          :shallow => "LayoutBeta-region--shallow-divider"
        }.freeze
        RESPONSIVE_DIVIDER_OPTIONS = RESPONSIVE_DIVIDER_MAPPINGS.keys.freeze
        # @param responsive_divider [Symbol] <%= one_of(Primer::Beta::Layout::Bookend::RESPONSIVE_DIVIDER_OPTIONS) %>
        # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
        def initialize(responsive_divider: RESPONSIVE_DIVIDER_DEFAULT, **system_arguments)
          @system_arguments = system_arguments
          @system_arguments[:classes] = class_names(
            @system_arguments[:classes],
            "LayoutBeta-region",
            RESPONSIVE_DIVIDER_MAPPINGS[fetch_or_fallback(RESPONSIVE_DIVIDER_OPTIONS, responsive_divider, RESPONSIVE_DIVIDER_DEFAULT)]
          )
        end

        def call
          render(Primer::BaseComponent.new(tag: :div, **@system_arguments)) { content }
        end
      end

      # The layout's pane content. This is a secondary, smaller region that is paired with the `Main` region.
      class Pane < Primer::Component
        TAG_DEFAULT = :div
        TAG_OPTIONS = [TAG_DEFAULT, :aside, :nav, :section].freeze

        # @param tag [Symbol] <%= one_of(Primer::Beta::Layout::Pane::TAG_OPTIONS) %>
        def initialize(tag: TAG_DEFAULT, **system_arguments)
          @system_arguments = system_arguments

          @system_arguments[:tag] = fetch_or_fallback(TAG_OPTIONS, tag, TAG_DEFAULT)
          @system_arguments[:classes] = class_names(
            "LayoutBeta-pane",
            @system_arguments[:classes]
          )
        end

        def call
          render(Primer::BaseComponent.new(**@system_arguments)) { content }
        end
      end
    end
  end
end