function test_fmpz_laurent_series_constructors()
   print("fmpz_laurent_series.constructors...")

   R, x = LaurentSeriesRing(ZZ, 30, "x")

   @test elem_type(R) == fmpz_laurent_series
   @test elem_type(FmpzLaurentSeriesRing) == fmpz_laurent_series
   @test parent_type(fmpz_laurent_series) == FmpzLaurentSeriesRing

   @test isa(R, FmpzLaurentSeriesRing)

   a1 = x^3 + 2x + 1

   @test isa(a1, fmpz_laurent_series)

   b1 = R(a1)

   @test isa(b1, fmpz_laurent_series)

   c1 = R(fmpz[1, 3, 5], 3, 5, 0, 1)

   @test isa(c1, fmpz_laurent_series)

   g1 = R(1)
   h1 = R(ZZ(2))
   k1 = R()

   @test isa(g1, fmpz_laurent_series)
   @test isa(h1, fmpz_laurent_series)
   @test isa(k1, fmpz_laurent_series)

   println("PASS")
end

function test_fmpz_laurent_series_manipulation()
   print("fmpz_laurent_series.manipulation...")

   R, t = PolynomialRing(ZZ, "t")
   S, x = LaurentSeriesRing(R, 30, "x")

   @test max_precision(S) == 30

   a = 2x + x^3
   b = O(x^4)

   @test pol_length(a) == 2
   @test pol_length(b) == 0

   @test valuation(a) == 1
   @test valuation(b) == 4

   @test precision(a) == 31
   @test precision(b) == 4

   @test isgen(gen(S))

   @test iszero(zero(S))

   @test isone(one(S))

   @test isunit(-1 + x + 2x^2)

   @test isequal(deepcopy(a), a)
   @test isequal(deepcopy(b), b)

   @test normalise(a, 2) == 2

   @test coeff(a, 1) == 2
   @test coeff(b, 7) == 0

   println("PASS")
end

function test_fmpz_laurent_series_unary_ops()
   print("fmpz_laurent_series.unary_ops...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:300
      f = rand(R, -12:12, -10:10)

      @test isequal(-(-f), f)
      @test iszero(f + (-f))
   end

   println("PASS")
end

function test_fmpz_laurent_series_binary_ops()
   print("fmpz_laurent_series.binary_ops...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:100
      f = rand(R, -12:12, -10:10)
      g = rand(R, -12:12, -10:10)
      h = rand(R, -12:12, -10:10)
      @test isequal(f + g, g + f)
      @test isequal(f + (g + h), (f + g) + h)
      @test isequal(f*g, g*f)
      @test isequal(f*(g*h), (f*g)*h)
      @test isequal(f - g, -(g - f))
      @test (f - h) + h == f
      @test f*(g + h) == f*g + f*h
      @test f*(g - h) == f*g - f*h
   end

   println("PASS")
end

function test_fmpz_laurent_series_adhoc_binary_ops()
   print("fmpz_laurent_series.adhoc_binary_ops...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:500
      f = rand(R, -12:12, -10:10)
      c1 = rand(ZZ, -10:10)
      c2 = rand(ZZ, -10:10)
      d1 = rand(zz, -10:10)
      d2 = rand(zz, -10:10)

      @test isequal(c1*f - c2*f, (c1 - c2)*f)
      @test isequal(c1*f + c2*f, (c1 + c2)*f)
      @test isequal(d1*f - d2*f, (d1 - d2)*f)
      @test isequal(d1*f + d2*f, (d1 + d2)*f)

      @test isequal(f*c1 - f*c2, f*(c1 - c2))
      @test isequal(f*c1 + f*c2, f*(c1 + c2))
      @test isequal(f*d1 - f*d2, f*(d1 - d2))
      @test isequal(f*d1 + f*d2, f*(d1 + d2))
   end

   println("PASS")
end

function test_fmpz_laurent_series_comparison()
   print("fmpz_laurent_series.comparison...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:500
      f = rand(R, -12:12, -10:10)
      g = deepcopy(f)
      h = R()
      while iszero(h)
         h = rand(R, -12:12, -10:10)
      end

      @test f == g
      @test isequal(f, g)
      @test (precision(h) > min(precision(f), precision(g)) || f != g + h)
      @test (precision(h) > min(precision(f), precision(g)) || !isequal(f, g + h))
   end

   println("PASS")
end

function test_fmpz_laurent_series_adhoc_comparison()
   print("fmpz_laurent_series.adhoc_comparison...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:500
      f = R()
      while f == 0
         f = rand(R, 0:0, -10:10)
      end
      f += rand(R, 1:12, -10:10)
      c1 = rand(ZZ, -10:10)
      d1 = rand(zz, -10:10)

      @test R(c1) == c1
      @test c1 == R(c1)
      @test R(d1) == d1
      @test d1 == R(d1)

      @test R(c1) != c1 + f
      @test c1 != R(c1) + f
      @test R(d1) != d1 + f
      @test d1 != R(d1) + f
   end

   println("PASS")
end

function test_fmpz_laurent_series_powering()
   print("fmpz_laurent_series.powering...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")

   for iter = 1:100
      f = rand(R, -12:12, -10:10)
      r2 = R(1)

      for expn = 0:10
         r1 = f^expn

         @test (f == 0 && expn == 0 && r1 == 0) || isequal(r1, r2)

         r2 *= f
      end
   end

   println("PASS")
end

function test_fmpz_laurent_series_shift()
   print("fmpz_laurent_series.shift...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:300
      f = rand(R, -12:12, -10:10)
      s = rand(0:12)

      @test isequal(shift_right(shift_left(f, s), s), f)
      @test isequal(shift_left(f, s), x^s*f)
      @test precision(shift_right(f, s)) == precision(f) - s
   end

   println("PASS")
end

function test_fmpz_laurent_series_truncation()
   print("fmpz_laurent_series.truncation...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:300
      f = rand(R, -12:12, -10:10)
      s = rand(-12:12)

      @test truncate(f, s) == f
      @test isequal(truncate(f, s), f + O(x^s))
      @test precision(truncate(f, s)) == min(precision(f), s)
   end

   println("PASS")
end

function test_fmpz_laurent_series_inversion()
   print("fmpz_laurent_series.inversion...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:300
      f = R()
      while iszero(f) || !isunit(polcoeff(f, 0))
         f = rand(R, -12:12, -10:10)
      end

      @test f*inv(f) == 1
   end

   println("PASS")
end

function test_fmpz_laurent_series_square_root()
   print("fmpz_laurent_series.square_root...")
 
   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:300
      f = rand(R, -12:12, -10:10)
      g = f^2
 
      @test isequal(sqrt(g)^2, g)
   end
 
   println("PASS")
end
 
function test_fmpz_laurent_series_exact_division()
   print("fmpz_laurent_series.exact_division...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:300
      f = rand(R, -12:12, -10:10)
      g = rand(R, -12:12, -10:10)
      while iszero(g) || !isunit(polcoeff(g, 0))
         g = rand(R, -12:12, -10:10)
      end

      @test divexact(f, g)*g == f
   end

   println("PASS")
end

function test_fmpz_laurent_series_adhoc_exact_division()
   print("fmpz_laurent_series.adhoc_exact_division...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
   for iter = 1:300
      f = rand(R, -12:12, -10:10)
      c = ZZ()
      while c == 0
         c = rand(ZZ, -10:10)
      end

      @test isequal(divexact(f*c, c), f)
   end

   println("PASS")
end

function test_fmpz_laurent_series_special_functions()
   print("fmpz_laurent_series.special_functions...")

   R, x = LaurentSeriesRing(ZZ, 10, "x")
    
   @test isequal(exp(2x + x^2 + O(x^3)), 1 + 2*x + 3*x^2 + O(x^3))

   println("PASS")
end

function test_fmpz_laurent_series()
   test_fmpz_laurent_series_constructors()
   test_fmpz_laurent_series_manipulation()
   test_fmpz_laurent_series_unary_ops()
   test_fmpz_laurent_series_binary_ops()
   test_fmpz_laurent_series_adhoc_binary_ops()
   test_fmpz_laurent_series_comparison()
   test_fmpz_laurent_series_adhoc_comparison()
   test_fmpz_laurent_series_powering()
   test_fmpz_laurent_series_shift()
   test_fmpz_laurent_series_truncation()
   test_fmpz_laurent_series_exact_division()
   test_fmpz_laurent_series_adhoc_exact_division()
   test_fmpz_laurent_series_inversion()
   test_fmpz_laurent_series_square_root()
   test_fmpz_laurent_series_special_functions()

   println("")
end
