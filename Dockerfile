#   docker build -t perl-eval .
#   docker run --rm --network none --read-only --tmpfs /tmp \
#     perl-eval XML-Simple-2.25 Llama-3.3-70B-Instruct 1 initial

FROM registry.access.redhat.com/ubi8/ubi:8.10

# RHEL 8 ships Perl 5.26.3. gcc, make and expat are only needed to build XML::Parser.
RUN dnf -y install perl perl-core perl-App-cpanminus gcc make expat-devel \
 && dnf clean all

# Versions from the paper.
RUN cpanm --notest \
        'Test2::V0@0.000139' \
        'Devel::Cover@1.36' \
        'XML::NamespaceSupport@1.04' \
        'XML::SAX@0.15' \
        XML::SAX::Expat

# Subjects, unpacked but not installed, so tests run against this source.
WORKDIR /subjects
RUN curl -fsSLO https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-Simple-2.25.tar.gz \
 && curl -fsSLO https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz \
 && curl -fsSLO https://cpan.metacpan.org/authors/id/K/KW/KWILLIAMS/Path-Class-0.37.tar.gz \
 && for f in *.tar.gz; do tar xzf "$f"; done \
 && rm -f *.tar.gz

COPY results /artifact

# Run one cell: <subject> <model> <run> [stage].
COPY run-cell /usr/local/bin/run-cell
RUN sed -i 's/\r$//' /usr/local/bin/run-cell && chmod +x /usr/local/bin/run-cell

# Some tests chmod 0000 a file and assert that access fails. Root bypasses
# file permissions, so as root those assertions would report the wrong result.
USER 1000

ENTRYPOINT ["/usr/local/bin/run-cell"]
