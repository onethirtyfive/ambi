module DSLCleanRoom
  shared_context 'DSL clean room' do |dsl|
    let(:scope)       { ::Ambi::Scope.new(subject) }
    let!(:clean_room) { dsl_clean_room.new(scope)  }

    let(:dsl_clean_room) do
      Class.new(BasicObject) do
        include dsl

        attr_reader :scope

        def initialize(scope)
          @scope = scope
        end
      end
    end
  end
end