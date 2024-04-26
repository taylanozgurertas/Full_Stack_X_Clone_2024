import 'package:fpdart/fpdart.dart';

import 'error/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;

//! THIS IS OUR TYPEDEFINITIONS FOR EASY CODING
