FROM python:3.7-slim AS build
ADD server.py /app/server.py
WORKDIR /app
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
RUN pip install asyncua==0.9.14
RUN pip show asyncua

FROM gcr.io/distroless/python3
COPY --from=build /app /app
COPY --from=build /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages
ENV PYTHONPATH=/usr/local/lib/python3.7/site-packages
WORKDIR /app
EXPOSE 4840
CMD ["server.py"]