import 'package:advanced_flutter_course/app/core/factories/repository_factory.dart';
import 'package:advanced_flutter_course/app/presentation/rx/next_event_rx_presenter.dart';

final class PresenterFactory {

  PresenterFactory._();

  static NextEventRxPresenter makeNextEventRxPresenter() {

    final repository = RepositoryFactory.makeLoadNextEventApiWithCacheFallbackRepository();

    /// Here my NextEventRxPresenter doesn't depend on the repository, but
    /// it does depend on the method's signature. So even if I have here the
    /// repository instance, I don't pass it to the presenter. So I don't
    /// have a dependency between the presenter and the repository
    /// (controller and infra) what if I had one it would inflict the
    /// separation of layers defined by the Clean Arch.
    /// This happened because my usecase was serving just as a proxy,
    /// I didn't have any business rule inside it. So it just called
    /// the method in the repository. It was an Middle-Man.
    /// I have two principles from SOLID here.
    /// 1 - O -> Open Closed Principle (add function without altering
    /// what already exist)
    /// 2 - L -> Liskov Substituion (inject function from another class
    /// as this one has the same signature)
    /// The first one is because I used the Composite Pattern to add new
    /// functionality, so I extended what was working and didn't have
    /// to change the implementation, I just added a new one. And I
    /// let the same method's signature in this Composite implementation.
    /// The second takes advantage of the first principle quoted above,
    /// because having the same signature, I can replace the primary
    /// implementation that just get data from the api for the implementation
    /// that join the api and cache. Even if the principle says the replacing
    /// is about the father substitute the child, I can apply this in here
    /// as I can substitute the implementations because they have the same
    /// signature/contract. The matter here is if I replace the implementation
    /// it will work correctly as I expect.
    /// And following ahead I can quote the D principle, that stands for
    /// Dependendy Injection, where I need to depend on a abstraction. In
    /// this case, this abstraction is the signature/contract of the method.
    return NextEventRxPresenter(
      nextEventLoader: repository.loadNextEvent,
    );
  }
}