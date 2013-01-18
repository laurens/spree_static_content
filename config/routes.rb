class Spree::StaticPage
  def self.ensure_slug_prefix(slug)
    slug.start_with?('/') ? slug : "/#{slug}"
  end

  def self.matches?(request)
    slug = request.symbolized_path_parameters[:slug]
    Spree::Page.visible.exists?(:slug => ensure_slug_prefix(slug))
  end
end

Spree::Core::Engine.routes.prepend do
  namespace :admin do
    resources :pages
  end

  constraints(Spree::StaticPage) do
    match '/(*slug)', :to => 'static_content#show', :via => :get, :as => 'static', :defaults => {:slug => '/' }
  end
end
