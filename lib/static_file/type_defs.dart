import 'package:blogapp/static_file/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T>  = Future<Either<Failure,T>>;
typedef FutureVoid = FutureEither<void>;