/**
  * We don't need any private projects, it's a disgrace to the development community
  * Every project should be open and free (free as in freedom)
  * This here is an attempt to curb such misdemeanours :
  *
  * * This script is going to pick every Private project in a Gitlab distribution and
  * * clinically convert them to Internal so that everyone inside an organisation can
  * * see it, fork it, contribute to it & enjoy the freedom of open source development
  *
  * Now to some technical details:
  * * It's written in Scala and meant to run NOT in scala's own REPL but in awesome [Ammonite-REPL](http://www.lihaoyi.com/Ammonite/#Ammonite-REPL)
  * * There is only one external dependency of [scalaj-http] (https://github.com/scalaj/scalaj-http)
  * * The same can be loaded in the same Ammonite REPL
  * * * `interp.load.ivy("org.scalaj" %% "scalaj-http" % "2.3.0")`
  * *
  * * [uPickle](http://www.lihaoyi.com/upickle-pprint/upickle/#GettingStarted) library comes bundled with Ammonite
  *
  * * Ref to Gitlab APIs for Projects - https://docs.gitlab.com/ce/api/projects.html
  *
  **/


import scalaj.http._
import upickle.json._
import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global
import scala.util.Success
import scala.util.Failure

/**
  * If you happen to be in a hostile environment i.e. behind a proxy
  * Then uncomment and update based on your own settings

 val props = System.getProperties
 props.setProperty("http.proxyHost","YOUR_OWN_PROXY_HOST_GOES_HERE")
 props.setProperty("http.proxyPort","YOUR_OWN_PROXY_PORT_GOES_HERE")
 props.setProperty("http.proxyUser","YOUR_OWN_USER_NAME_GOES_HERE")
 props.setProperty("http.proxyPassword","YOUR_OWN_PASSWORD_GOES_HERE")
 */

// First some types & constants aka boilerplates
type IDNameTuple = (List[Option[upickle.Js.Value]], String)
type ResponsesF = List[Future[HttpResponse[String]]]

val GITLAB_URL = "https://code.cognizant.com"
val GITLAB_PERSONAL_ACCESS_TOKEN = "CDCoWq6CkSsUWx8Spxww"
val DEFAULT_FETCH_PRIVATE_PROJECTS_API = "api/v3/projects/all?visibility=private&per_page=100"
val GITLAB_PROJECTS_API = "api/v3/projects"


def getTheCulprits(from: Option[String] = None): IDNameTuple = {
  // There might be a lot of blood to shed, we don't want to rush
  Thread.sleep(3000)

  val link = from.getOrElse(s"$GITLAB_URL/$DEFAULT_FETCH_PRIVATE_PROJECTS_API")
  val response = Http(link).
    header("PRIVATE-TOKEN", s"$GITLAB_PERSONAL_ACCESS_TOKEN").
    option(HttpOptions.allowUnsafeSSL).asString

  val parsedIds = upickle.json.read(response.body)
  .asInstanceOf[upickle.Js.Arr].value.toList
  .map(v =>
         v.asInstanceOf[upickle.Js.Obj]
         .value.toMap
         .get("id"))
  val nextLink = response.header("Link").getOrElse("")
    .split(",")
    .filter(_.contains("rel=\"next\""))
    .map(x => x.trim.split(';').head.trim.drop(1).reverse.drop(1).reverse)
    .headOption.getOrElse("")

  (parsedIds, nextLink)
}


def neutraliseThreat(id: upickle.Js.Value): Future[HttpResponse[String]] = {
  // We don't block coz we have a long way to go
  Future[HttpResponse[String]] {
    Http(s"$GITLAB_URL/$GITLAB_PROJECTS_API/$id")
      .headers(("PRIVATE-TOKEN", s"$GITLAB_PERSONAL_ACCESS_TOKEN"))
      .postForm
      .params(("visibility_level", "10")) // this is the bullet of Internal visibility
      .method("PUT")
      .option(HttpOptions.allowUnsafeSSL).asString
  }
}

// No bodies or buddies should left behind
def fire(listOfIdsAndNextLink: IDNameTuple, count: Int, acc: ResponsesF): ResponsesF = {
  if (listOfIdsAndNextLink._2.isEmpty && count > 0) acc
  else {
    val futures = for {
      maybeProjId <- listOfIdsAndNextLink._1
      projId <- maybeProjId
    } yield neutraliseThreat(projId)

    fire(
      if (listOfIdsAndNextLink._2.nonEmpty) getTheCulprits(Some(listOfIdsAndNextLink._2)) else (List(), ""),
      count + 1,
      acc ++ futures)
  }
}

def attack() {
  val allCasualties  = fire(getTheCulprits(), 0, List())
  println(allCasualties.length)
  allCasualties.map {
    _ onComplete {
      case Success(response) if response.code != 200 => attack() //there are some edge cases when a repeat attack is necessary
      case Success(response) => println(response.code)
      case Failure(ex) => println(ex.getMessage)
    }
  }
}
