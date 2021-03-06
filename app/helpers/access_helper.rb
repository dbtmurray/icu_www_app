module AccessHelper
  def access_menu(selected, options, default)
    accs = options.map { |acc| [t("access.#{acc}"), acc] }
    accs.unshift([t(default), ""]) if default && accs.size > 1
    options_for_select(accs, selected)
  end
end
