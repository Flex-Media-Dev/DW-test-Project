<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Xml;
using System.Xml.Xsl;

// @see http://stackoverflow.com/a/6234787/2380601
class Handler : IHttpHandler
{
	public void ProcessRequest(HttpContext context)
	{
		OutputCachedPage page = new OutputCachedPage(new OutputCacheParameters
		{
			Duration = 1,
			Location = OutputCacheLocation.Server,
			VaryByParam = "*"
		});
		page.ProcessRequest(HttpContext.Current);
	}

	public bool IsReusable
	{
		get
		{
			return false;
		}
	}

	private sealed class OutputCachedPage : Page
	{
		private OutputCacheParameters _cacheSettings;

		public OutputCachedPage(OutputCacheParameters cacheSettings)
		{
			// Tracing requires Page IDs to be unique.
			ID = Guid.NewGuid().ToString();
			_cacheSettings = cacheSettings;
		}

		protected override void FrameworkInitialize()
		{
			// when you put the < %@ OutputCache %> directive on a page, the generated code calls InitOutputCache() from here
			base.FrameworkInitialize();
			InitOutputCache(_cacheSettings);
		}

		private HttpRequest request;
		private HttpResponse response;

		public void ProcessRequest(HttpContext context)
		{
			request = context.Request;
			response = context.Response;

			var baseUrl = string.Format("http://{0}", request.Url.Host);
			var url = request.QueryString["url"];
			if (url != null && !url.StartsWith("http://"))
			{
				url = baseUrl + "/" + url.TrimStart('/');
			}
			var name = request.QueryString["name"];
			if (string.IsNullOrEmpty(name))
			{
				name = "default";
			}

			var xsltUrl = string.Format("{0}{1}", baseUrl, System.Text.RegularExpressions.Regex.Replace(request.Url.LocalPath, @"\.as[hp]x$", ".xslt"));


			if (!string.IsNullOrEmpty(url))
			{
				response.ContentType = "text/plain";
				// response.Write(string.Format("// baseUrl: {0}\n", baseUrl));
				response.Write(string.Format("// url:  {0}\n", url));
				response.Write(string.Format("// name: {0}\n", name));
				// response.Write(string.Format("// xsltUrl: {0}\n", xsltUrl));

				var client = new System.Net.WebClient();
				var content = string.Empty;
				try
				{
					try
					{
						content = string.Format("<Styles>{0}</Styles>", client.DownloadString(url));
					}
					catch (Exception ex) 
					{
						response.Write(string.Format("// {0}\n", ex.Message));
						content = "<Styles/>";
					}

					var transform = new XslCompiledTransform();
					transform.Load(xsltUrl, new XsltSettings()
					{
						EnableScript = true
					}, new XmlUrlResolver());

					var writer = new StringWriter();

					var args = new XsltArgumentList();
					args.AddParam("name", string.Empty, name);
					using (var reader = XmlReader.Create(new StringReader(content)))
					{
						transform.Transform(reader, args, writer);
					}
					writer.Close();
					response.Write(writer.ToString());
				}
				catch (Exception ex)
				{
					InvalidRequest(ex);
				}
			}
			else
			{
				InvalidRequest("Missing url");
			}
		}

		private void InvalidRequest(Exception exeption)
		{
			InvalidRequest(exeption.Message);
		}

		private void InvalidRequest(string message)
		{
			response.Clear();
			response.End();
			//response.StatusCode = 400;
			//response.ContentType = "text/plain";
			//response.Clear();
			//response.Write("Invalid request\n");
		}
	}
}
