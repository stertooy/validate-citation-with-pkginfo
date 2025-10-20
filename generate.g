Read("PackageInfo.g");
info := GAPInfo.PackageInfoCurrent;

# Add basic info
text := Concatenation(
    "cff-version: 1.2.0\n",
    "message: If you use this GAP package, please cite it using the metadata from this file.\n",
    "type: software\n",
    "title: ", info.PackageName, "\n",
    "abstract: ", info.Subtitle, "\n",
    "version: ", info.Version, "\n"
);

spl := SplitString( info.Date, "/" );
if Length( spl ) = 3 then
    dat := Concatenation(
        spl[3], "-", spl[2], "-", spl[1]
    );
else
    dat := spl[1];
fi;
text := Concatenation( text,
    "date-released: ",dat,"\n",
    "license: ",info.License,"\n"
);

authors := [];
contact := [];

# Add persons to author or contacts
if IsBound( info.Persons ) then
    for person in info.Persons do
        prsn := Concatenation(
            "  - family-names: ", person.LastName, "\n"
        );
        if IsBound( person.FirstNames ) then
            prsn := Concatenation( prsn,
                "    given-names: ", person.FirstNames, "\n"
            );
        fi;
        if IsBound( person.Institution ) then
            prsn := Concatenation( prsn,
                "    affiliation: ", person.Institution, "\n"
            );
        fi;
        if IsBound( person.Email ) then
            prsn := Concatenation( prsn,
                "    email: ", person.Email, "\n"
            );
        fi;
        if IsBound( person.WWWHome ) then
            prsn := Concatenation( prsn,
                "    website: ", person.WWWHome, "\n"
            );
        fi;
        if IsBound( person.IsAuthor ) and person.IsAuthor then
            Add( authors, prsn );
        elif IsBound( person.IsMaintainer ) and person.IsMaintainer then
            Add( contact, prsn );
        fi;
    od;
fi;

# Add Support Email to contacts
if IsBound( info.SupportEmail ) then
    supp := Concatenation(
        "  - name: Support Email\n",
        "    email: ", info.SupportEmail, "\n"
    );
    Add( contact, supp );
fi;

# Add Issue Tracker to contacts
if IsBound( info.IssueTrackerURL ) then
    supp := Concatenation(
        "  - name: Issue Tracker\n",
        "    website: ", info.IssueTrackerURL, "\n"
    );
    Add( contact, supp );
fi;

if not IsEmpty( authors ) then
    text := Concatenation( text,
        "authors:\n"
    );
    for author in authors do
        text := Concatenation( text,
            author
        );
    od;
fi;
if not IsEmpty( contact ) then
    text := Concatenation( text,
        "contact:\n"
    );
    for cont in contact do
        text := Concatenation( text, cont );
    od;
fi;

# Add repository and website
if IsBound( info.SourceRepository ) and IsBound( info.SourceRepository.URL ) then
    text := Concatenation( text,
        "repository-code: ", info.SourceRepository.URL, "\n"
    );
fi;
text := Concatenation( text,
    "url: ", info.PackageWWWHome, "\n"
);

# Add keywords
if IsBound( info.Keywords ) and not IsEmpty( info.Keywords ) then
    text := Concatenation( text,
        "keywords:\n"
    );
    for keyword in info.Keywords do
        text := Concatenation( text,
            "  - ", keyword, "\n"
        );
    od;
fi;

PrintTo( Filename( DirectoryCurrent(), "CITATION-generated.cff" ), text );
QuitGap();
