class Ability
  include CanCan::Ability

  def initialize(user, group)
    member = group.get_member_to(user) || Member.new

    case member.permission
    when 'admin'
      can :manager, :all
    when 'collaborator'
      can :read, :all
      can [:read, :create], :Song
      can :manage, :PresentationsSong
      can :destroy, :Member, user_id: user.id
    when 'default'
      can :read, :all
      can :destroy, :Member, user_id: user.id
    end

  end

  def to_list
    rules.map do |rule|
      object = { actions: rule.actions, subject: rule.subjects.map{ |s| s.is_a?(Symbol) ? s : s.name } }
      object[:conditions] = rule.conditions unless rule.conditions.blank?
      object[:inverted] = true unless rule.base_behavior
      object
    end
  end
end
