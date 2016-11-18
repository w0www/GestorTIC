module GmanagersHelper

  def link_to_group(id)
    name = Gmanager.get_group_name_by_id(id)
    return link_to name, gmanager_path(id, :project_id => params[:project_id])
  end

  def render_group_by_id(id)
    return Gmanager.get_group_name_by_id(id)
  end

  def render_cf_keys()
    return Gmanager.get_user_cf_keys()
  end

  def render_cf_values(id)
    return Gmanager.get_user_cf_values(id)
  end

  def render_group_owner(idgr)
    id = Gmanager.get_group_owner(idgr)
    return id
  end

  def render_user_name(id)
    ret =  Gmanager.get_user_name(id)    
    if not ret
      return Gmanager.get_user_name('1')
    else
      return ret
    end
  end

  def render_possible_owners()
    users = User.all
    ret = []
    for u in users
      ret.append([u['firstname'].to_s + " " + u['lastname'].to_s, u['id']])
    end
    return ret
  end

end
