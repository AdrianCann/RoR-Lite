require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'session'



class ControllerBase
  attr_reader :params, :req, :res

  # setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    raise "Already rendered" if already_built_response?
    @res.body = content
    @res.content_type = type
    
    session.store_session(@res)
    
    @already_built_response = true
  end

  # helper method to alias @already_built_response
  def already_built_response?
    !!@already_built_response
  end

  # set the response status code and header
  def redirect_to(url)
    raise "Already rendered man" if already_built_response?
    @res.status = 302
    @res.header["location"] = url

    # set_redirect(302, url)
    @already_built_response = true

    session.store_session(@res)
    nil
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)

    path = File.join("views", self.class.name.underscore, "#{template_name}.html.erb")
    #how to check if this exists before next line

    contents = File.read(path)
    #contents = File.read("something/chickens/dinner.rb")
    erb = ERB.new(contents).result(binding)

    render_content(erb, "text/html")
  end

  # method exposing a `Session` object
  def session

    @session ||= Session.new(@req)

  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    self.render(name) unless already_built_response?
    nil
  end
end
